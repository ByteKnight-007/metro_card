require './metro_card'

RSpec.describe MetroCard do
  let(:card_number) { '12345' }
  let(:initial_balance) { 100 }
  let(:metro_card) { MetroCard.new(card_number, initial_balance) }

  describe '#initialize' do
    it 'creates a new MetroCard instance with given card_number and initial_balance' do
      expect(metro_card.card_number).to eq(card_number)
      expect(metro_card.balance).to eq(initial_balance)
    end
  end

  describe '#recharge' do
    it 'increases the balance by the given amount' do
      recharge_amount = 50
      metro_card.recharge(recharge_amount)
      expect(metro_card.balance).to eq(initial_balance + recharge_amount)
    end
  end

  describe '#deduct' do
    it 'decreases the balance by the given amount' do
      deduction_amount = 30
      metro_card.deduct(deduction_amount)
      expect(metro_card.balance).to eq(initial_balance - deduction_amount)
    end
  end
end
