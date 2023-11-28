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
