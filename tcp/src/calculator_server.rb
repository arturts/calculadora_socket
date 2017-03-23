require 'socket'
require_relative 'calculator'
require_relative 'parser'

class CalculatorServer
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
    @tcp_server = TCPServer.new(@ip, @port)
    puts "Calculator Server listening on #{@ip}:#{@port}."

    loop do
      client = @tcp_server.accept
      @threads << handle_client(client)
    end
  end

  private

  def shutdown!
    @threads.each(&:exit)
    puts "Shutting down gracefully"
    sleep 1
    exit
  end

  def handle_client(client)
    Thread.new do
      _, client_port, _, client_ip = client.peeraddr

      puts "Client connected on #{client_ip}:#{client_port}."

      catch(:client_disconnected) do
        loop { handle_request(client) }
      end

      client.close

      puts "Client disconnected."
    end
  end

  def handle_request(client)
    _, client_port, _, client_ip = client.peeraddr
    message = client.gets&.strip

    throw(:client_disconnected) if message.nil?

    puts "Received message: \"#{message}\" from #{client_ip}:#{client_port}"

    request = @parser.parse(message)
    response = @calculator.calculate(*request)

    client << response << "\n"
  rescue StandardError => e
    client << e.message << "\n"
  end
end
