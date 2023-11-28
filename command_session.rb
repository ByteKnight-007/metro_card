require_relative 'metro_card'
require_relative 'fare_constants'

class CommandSession
  attr_reader :passengers, :collection_summary, :passenger_summary
  
  def initialize
    @passengers = {}
    @collection_summary = Hash.new { |h, k| h[k] = { collected: 0, discount: 0 } }
    @passenger_summary = Hash.new { |h, k| h[k] = { ADULT: 0, KID: 0, SENIOR_CITIZEN: 0 } }
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
    @passengers[card_number] = MetroCard.new(card_number, balance.to_i)
  end

  def handle_check_in(card_number, passenger_type, station)
    passenger = @passengers[card_number]
    @collection_summary[station.to_sym] ||= { collected: 0, discount: 0 }

    fare = calculate_fare(card_number, passenger_type, station)

    handle_less_balance(passenger, fare, station) if passenger.balance.nil? || passenger.balance < fare
    passenger.deduct(fare)
    @collection_summary[station.to_sym][:collected] += fare
    update_passenger_summary(station, passenger_type)
  end

  def handle_less_balance(passenger, fare, station)
    recharge_amount = fare - passenger.balance
    passenger.recharge(recharge_amount)
      
    @collection_summary[station.to_sym][:collected] += recharge_amount * FareConstants::LOW_BALANCE_CHARGE
  end

  def calculate_fare(card_number, passenger_type, station)
    if @travelling_card.include?(card_number)
      fare = FareConstants::CENTRAL_AIRPORT_FARE[passenger_type.downcase] * FareConstants::TRIP_DISCOUNT

      @collection_summary[station.to_sym][:discount] += fare
      @travelling_card.delete(card_number)
    else  
      fare = FareConstants::CENTRAL_AIRPORT_FARE[passenger_type.downcase]
      @travelling_card.push(card_number)
    end
  
    fare
  end

  def update_passenger_summary(station, passenger_type)
    @passenger_summary[station.to_sym][passenger_type.to_sym] += 1
  end

  def print_summary
    [:CENTRAL, :AIRPORT].each do |station|
      summary = @collection_summary[station]
      puts "TOTAL_COLLECTION #{station.upcase} #{summary[:collected].to_i} #{summary[:discount].to_i}"
      puts 'PASSENGER_TYPE_SUMMARY'
      @passenger_summary[station.to_sym].each do |type, count|
        puts "#{type.upcase} #{count}" unless count.zero?
      end
      puts ""
    end
  end
end
