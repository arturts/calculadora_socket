require 'socket'

class CalculatorClient
  QUIT_REGEX = /\Aq|exit\Z/.freeze

  def initialize(ip:, port:)
    @ip     = ip
    @port   = port
  end

  def start!
    @server = TCPSocket.new(@ip, @port)
    puts "Connected to Calculator Server at #{@ip}:#{@port}."

    catch(:eol) do
      loop do
        print "> "

        message = gets&.strip

        throw(:eol) if message.nil? || QUIT_REGEX.match(message)

        @server << message << "\n"

        puts @server.gets
      end
    end

    puts "Goodbye."
  rescue Errno::ECONNREFUSED
    puts "Connection refused. Is there a running Calculator Server at"\
      " #{@ip}:#{@port}?"
  rescue Errno::EPIPE
    puts "Lost connection to the Calculator Server."
  end
end
