# require 'command_session'
require './command_session_manager'

RSpec.describe CommandSessionManager do
  let(:manager) { CommandSessionManager.new }

  describe '#process_command' do
    it 'handles BALANCE command' do
      card_number = '12345'
      balance = '100'
      manager.process_command("BALANCE #{card_number} #{balance}")

      expect(manager.instance_variable_get(:@command_session).passengers[card_number].balance).to eq(100)
    end

    it 'handles CHECK_IN command' do
      card_number = '12345'
      passenger_type = 'ADULT'
      station = 'CENTRAL'
      initial_balance = '200'
      manager.process_command("BALANCE #{card_number} #{initial_balance}")
      manager.process_command("CHECK_IN #{card_number} #{passenger_type} #{station}")
      
      expect(manager.instance_variable_get(:@command_session).collection_summary[station.to_sym][:collected]).to eq(200)
      expect(manager.instance_variable_get(:@command_session).passenger_summary[station.to_sym][:ADULT]).to eq(1)
    end

    it 'handles PRINT_SUMMARY command' do
      card_number = '12345'
      passenger_type = 'ADULT'
      station = 'CENTRAL'
      initial_balance = '200'
      manager.process_command("BALANCE #{card_number} #{initial_balance}")
      manager.process_command("CHECK_IN #{card_number} #{passenger_type} #{station}")
      manager.process_command("CHECK_IN #{card_number} #{passenger_type} AIRPORT")
      
      expected_output = "TOTAL_COLLECTION CENTRAL 200 0\nPASSENGER_TYPE_SUMMARY\nADULT 1\n\nTOTAL_COLLECTION AIRPORT 102 100\nPASSENGER_TYPE_SUMMARY\nADULT 1\n\n"
    
      expect { manager.process_command('PRINT_SUMMARY') }.to output(expected_output).to_stdout
    end

    it 'handles invalid command' do
      expect { manager.process_command('INVALID_COMMAND') }.to output("Invalid command: INVALID_COMMAND\n").to_stdout
    end
  end
end
