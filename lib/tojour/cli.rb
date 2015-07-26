require 'base64'
require_relative 'utils'
require_relative 'sock'
require_relative 'jour'

module Tojour
  class Cli
    def initialize(options)
      @options = options
    end

    def send_file(name)
      Jour.new(name, 'file').resolve do |r|
        Utils.log "Found #{name} running at #{r.target}:#{r.port}"
        File.open(@options[:send_filename]) do |f|
          Utils.log "Sending \"#{@options[:send_filename]}\"."
          Sock.new(@options).client(r.target, r.port) do |client|
            client.puts('### ' + @options[:send_filename])
            loop do
              begin
                client.puts(Base64.strict_encode64(f.readpartial(1024)))
              rescue EOFError
                client.puts '### done'
                break
              end
            end
            Utils.log "Done!"
            exit
          end
        end
      end
    end

    def receive_file(name)
      Jour.new(name, 'file').register(@options[:port]) do |r|
        Utils.log "Registered as #{name}."
        Sock.new(@options).server do |server|
          connection = server.accept
          file_name = connection.gets.chomp.gsub(/^### /, '')
          Utils.log "Receiving file \"#{file_name}\"."
          File.open(file_name, 'w') do |f|
            while line = connection.gets
              line = line.chomp
              break if line === '### done'
              f.write Base64.strict_decode64(line)
            end
          end
          Utils.log "Done!"
          exit
        end
      end
    end

    def output(name)
      Jour.new(name, 'file').resolve do |r|
        Utils.log "Found #{name} running at #{r.target}:#{r.port}"
        Sock.new(@options).client(r.target, r.port) do |client|
          Utils.log "Sending log data from STDIN."
          $stdin.each do |line|
            puts line
            client.puts(Base64.strict_encode64(line))
          end
        end
      end
    end

    def input(name)
      Jour.new(name, 'file').register(@options[:port]) do |r|
        Utils.log "Registered as #{name}."
        Sock.new(@options).server do |server|
          connection = server.accept
          Utils.log "Receiving log data."
          while line = connection.gets
            # next unless line
            line = line.chomp
            $stdout.puts Base64.strict_decode64(line)
          end
        end
      end
    end

    def list
      Jour.list do |kind, name|
        Utils.log("#{name} (#{kind})")
      end
    end
  end
end

