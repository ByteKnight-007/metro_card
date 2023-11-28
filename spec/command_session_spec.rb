require './command_session'

RSpec.describe CommandSession do
  let(:session) { CommandSession.new }

  describe '#initialize' do
    it 'initializes a CommandSession with default attributes' do
      expect(session.passengers).to be_empty
      expect(session.collection_summary).to eq({})
      expect(session.passenger_summary).to eq({})
      expect(session.instance_variable_get(:@travelling_card)).to be_empty
    end
  end

  describe '#handle_balance' do
    it 'adds a new passenger with a specified balance' do
      card_number = '12345'
      initial_balance = '100'
      session.process_command("BALANCE #{card_number} #{initial_balance}")

      expect(session.passengers[card_number].balance).to eq(100)
    end
  end

  # Other test cases here...

end

