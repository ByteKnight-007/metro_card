require_relative 'command_session'

class CommandSessionManager
  def initialize
    @command_session = CommandSession.new
  end

  def process_command(command)
    action, *params = command.split

    case action
    when 'BALANCE'
      @command_session.handle_balance(*params)
    when 'CHECK_IN'
      @command_session.handle_check_in(*params)
    when 'PRINT_SUMMARY'
      @command_session.print_summary
    else
      puts "Invalid command: #{command}"
    end
  end
end
