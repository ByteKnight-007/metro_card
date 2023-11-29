require_relative 'command_session_manager'

def main
  fileinput = ARGV[0]
  file = File.open(fileinput)
  session = CommandSessionManager.new
  
  file.readlines.each do |line|
    session.process_command(line.strip)
  end
end
  
main