require 'socket'
require_relative 'calculator'
require_relative 'parser'

class CalculatorServer
  BYTES = 4096

  def initialize(ip:, port:, calculator: Calculator.new, parser: Parser)
    @ip   = ip
    @port = port
    @calculator = calculator
    @parser = parser
    @threads = []

    [:INT, :TERM].each do |sig|
      trap(sig) { shutdown! }
    end
  end

  def start!
    @udp_socket = UDPSocket.new
    @udp_socket.bind(@ip, @port)
    puts "Calculator Server running on #{@ip}:#{@port}."

    loop do
      handle_message
    end
  end

  private

  def shutdown!
    puts "Shutting down gracefully"
    sleep 1
    exit
  end

  def handle_message
    message, client_info = @udp_socket.recvfrom(BYTES)
    client_ip, client_port = client_info[3], client_info[1]

    puts "Received message: \"#{message.strip!}\" from #{client_ip}:#{client_port}"

    handle_request(message, client_ip, client_port)
  end

  def handle_request(message, ip, port)
    request = @parser.parse(message)
    response = @calculator.calculate(*request).to_s

    @udp_socket.send(response, 0, Socket.sockaddr_in(port, ip))
  rescue StandardError => e
    @udp_socket.send(e.message, 0, Socket.sockaddr_in(port, ip))
  end
end
