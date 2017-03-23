require 'socket'
require 'timeout'

class CalculatorClient
  include Timeout

  BYTES = 4096
  QUIT_REGEX = /\Aq|exit\Z/.freeze

  def initialize(ip:, port:)
    @ip     = ip
    @port   = port
  end

  def start!
    @socket = UDPSocket.new

    catch(:eol) do
      loop do
        print "> "

        message = gets

        throw(:eol) if message.nil? || QUIT_REGEX.match(message)

        @socket.send(message, 0, Socket.sockaddr_in(@port, @ip))

        begin
          message, _ = timeout(10) { @socket.recvfrom(BYTES) }
          puts message
        rescue Timeout::Error
          puts 'No response from server, shutting down...'
          throw(:eol)
        end
      end
    end

    puts "Goodbye."
  end
end
