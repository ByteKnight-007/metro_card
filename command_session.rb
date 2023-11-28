require_relative 'metro_card'

class CommandSession
  attr_reader :passengers, :collection_summary, :passenger_summary

  def initialize
    @passengers = {}
    @collection_summary = Hash.new { |h, k| h[k] = { collected: 0, discount: 0 } }
    @passenger_summary = Hash.new { |h, k| h[k] = { ADULT: 0, SENIOR_CITIZEN: 0, KID: 0 } }
    @travelling_card = []
  end

  def process_command(command)
    action, *params = command.split

    case action
    when 'BALANCE'
      handle_balance(*params)
    when 'CHECK_IN'
      handle_check_in(*params)
    when 'PRINT_SUMMARY'
      print_summary
    else
      puts "Invalid command: #{command}"
    end
  end

  def handle_balance(card_number, balance)
    card = @passengers[card_number]
    if card
      card.recharge(balance.to_i)
    else
      @passengers[card_number] = MetroCard.new(card_number, balance.to_i)
    end
  end

  def handle_check_in(card_number, passenger_type, station)
    passenger = @passengers[card_number]
  
    unless passenger
      puts "Passenger with card number #{card_number} not found."
      return
    end

    @collection_summary[station.to_sym] ||= { collected: 0, discount: 0 }

    fare = calculate_fare(card_number, passenger_type, station)
    if passenger.balance.nil? || passenger.balance < fare
      recharge_amount = fare - passenger.balance
      passenger.recharge(recharge_amount)
      
      @collection_summary[station.to_sym][:collected] += recharge_amount * 0.02
    end

    passenger.deduct(fare)

    @collection_summary[station.to_sym][:collected] += fare
    update_passenger_summary(station, passenger_type)
  end

  def calculate_fare(card_number, passenger_type, station)
    fare_mapping = {
      'adult' => 200,
      'senior_citizen' => 100,
      'kid' => 50
    }

    if @travelling_card.include?(card_number)
      fare = fare_mapping[passenger_type.downcase] * 0.5

      @collection_summary[station.to_sym][:discount] += fare
      @travelling_card.delete(card_number)
    else  
      fare = fare_mapping[passenger_type.downcase]
      @travelling_card.push(card_number)
    end
  
    fare
  end

  def update_passenger_summary(station, passenger_type)
    @passenger_summary[station.to_sym][passenger_type.to_sym] += 1
  end

  def print_summary
    @collection_summary.each do |station, summary|
      puts "TOTAL_COLLECTION #{station.upcase} #{summary[:collected].to_i} #{summary[:discount].to_i}"
      puts 'PASSENGER_TYPE_SUMMARY'
      @passenger_summary[station.to_sym].each do |type, count|
        puts "#{type.upcase} #{count}" unless count.zero?
      end
      puts ""
    end
  end
end
