require 'socket'
require 'openssl'
require_relative 'utils'

Thread.abort_on_exception = true

module Tojour
  class Sock
    attr_accessor :options, :key_path, :crt_path, :port

    def initialize(options)
      @options = options
      @key_path = @options[:key_path]
      @crt_path = @options[:crt_path]
      @port = @options[:port]
    end

    def server(&block)
      Utils.log("Listening on port #{@port}.")
      block.call(ssl_server)
    end

    def client(host, port, &block)
      block.call(ssl_client(host, port))
    end

    def ssl_server
      server = TCPServer.new(@port)
      ssl_context = OpenSSL::SSL::SSLContext.new
      ssl_context.cert = OpenSSL::X509::Certificate.new(File.open(@crt_path))
      ssl_context.key = OpenSSL::PKey::RSA.new(File.open(@key_path))
      OpenSSL::SSL::SSLServer.new(server, ssl_context)
    end

    def ssl_client(host, port)
      socket = TCPSocket.new(host, port)
      expected_cert = OpenSSL::X509::Certificate.new(File.open(@crt_path))
      ssl_client = OpenSSL::SSL::SSLSocket.new(socket)
      ssl_client.sync_close = true
      ssl_client.connect
      if ssl_client.peer_cert.to_s != expected_cert.to_s
        $stderr.puts 'Unexpected certificate.'
        exit(1)
      end
      ssl_client
    end
  end
end

