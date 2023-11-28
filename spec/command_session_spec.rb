# command_session_spec.rb
require 'rspec'
require 'command_session'

RSpec.describe CommandSession do
  let(:session) { CommandSession.new }

  describe '#handle_balance' do
    it 'recharges the balance for an existing passenger' do
      card_number = '12345'
      initial_balance = 100
      recharge_amount = 50

      session.process_command("BALANCE #{card_number} #{initial_balance}")
      session.handle_balance(card_number, recharge_amount)

      expect(session.passengers[card_number].balance).to eq(initial_balance + recharge_amount)
    end

    it 'creates a new passenger card and sets balance if not found' do
      card_number = '67890'
      recharge_amount = 75

      session.handle_balance(card_number, recharge_amount)

      expect(session.passengers[card_number].balance).to eq(recharge_amount)
    end
  end

  # Add more describe blocks for other methods and their respective test cases
end
