class MetroCard
  attr_reader :card_number, :balance

  def initialize(card_number, initial_balance)
    @card_number = card_number
    @balance = initial_balance
  end

  def recharge(amount)
    @balance += amount
  end

  def deduct(amount)
    @balance -= amount
  end
end


class CommandSession
  attr_reader :passengers, :collection_summary, :passenger_summary

  def initialize
    @passengers = {}
    @collection_summary = {}
    @passenger_summary = {}
    @travelling_card = []
  end

  def process_command(command)
    parts = command.split(' ')
    action = parts[0]
    
    case action
    when 'BALANCE'
      card_number = parts[1]
      balance = parts[2].to_i
  
      # Check if the card already exists
      if @passengers[card_number]
        @passengers[card_number].recharge(balance)
      else
        new_card = MetroCard.new(card_number, balance)
        @passengers[card_number] = new_card
      end      
    when 'CHECK_IN'
      card_number = parts[1]
      passenger_type = parts[2]
      station = parts[3]
  
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
    when 'PRINT_SUMMARY'
      print_summary
    else
      puts "Invalid command: #{command}"
    end
  end

  def update_passenger_summary(station, passenger_type)
    @passenger_summary[station.to_sym] ||= { ADULT: 0, SENIOR_CITIZEN: 0, KID: 0 }
    @passenger_summary[station.to_sym][passenger_type.to_sym] += 1
  end

  def print_summary
    @collection_summary.each do |station, summary|
      puts "TOTAL_COLLECTION #{station.upcase} #{summary[:collected].to_i} #{summary[:discount].to_i}"
      puts 'PASSENGER_TYPE_SUMMARY'
      @passenger_summary[station.to_sym].each do |type, count|
        next if count.zero?
        puts "#{type.upcase} #{count}"
      end
      puts ""
    end
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
end

def main
  fileinput = ARGV[0]
  file = File.open(fileinput)
  session = CommandSession.new

  file.readlines.each do |line|
    session.process_command(line.strip)
  end
end

main

# t.process_command("BALANCE MC1 600")
# t.process_command("BALANCE MC2 500")
# t.process_command("BALANCE MC3 50")
# t.process_command("BALANCE MC4 50")
# t.process_command("BALANCE MC5 200")
# t.process_command("CHECK_IN MC1 ADULT CENTRAL")
# t.process_command("CHECK_IN MC2 SENIOR_CITIZEN CENTRAL")
# t.process_command("CHECK_IN MC1 ADULT AIRPORT")
# t.process_command("CHECK_IN MC3 KID AIRPORT")
# t.process_command("CHECK_IN MC4 ADULT AIRPORT")
# t.process_command("CHECK_IN MC5 KID AIRPORT")
# t.process_command("PRINT_SUMMARY")


# input = [
#   "BALANCE MC1 600",
#   "BALANCE MC2 500",
#   "BALANCE MC3 50",
#   "BALANCE MC4 50",
#   "BALANCE MC5 200",
#   "CHECK_IN MC1 ADULT CENTRAL",
#   "CHECK_IN MC2 SENIOR_CITIZEN CENTRAL",
#   "CHECK_IN MC1 ADULT AIRPORT",
#   "CHECK_IN MC3 KID AIRPORT",
#   "CHECK_IN MC4 ADULT AIRPORT",
#   "CHECK_IN MC5 KID AIRPORT",
#   "PRINT_SUMMARY"
# ]

# session = CommandSession.new
# input.each do |line|
#   session.process_command(line.strip)
# end

# t.process_command("BALANCE MC1 400")
# t.process_command("BALANCE MC2 100")
# t.process_command("BALANCE MC3 50")
# t.process_command("BALANCE MC4 50")
# t.process_command("CHECK_IN MC1 SENIOR_CITIZEN AIRPORT")
# t.process_command("CHECK_IN MC2 KID AIRPORT")
# t.process_command("CHECK_IN MC3 ADULT CENTRAL")
# t.process_command("CHECK_IN MC1 SENIOR_CITIZEN CENTRAL")
# t.process_command("CHECK_IN MC3 ADULT AIRPORT")
# t.process_command("CHECK_IN MC3 ADULT CENTRAL")
# t.process_command("PRINT_SUMMARY")
