require 'optparse'

module Tojour
  class OptParser
    attr_accessor :options, :argv, :method

    def initialize(argv)
      options = {
        is_send_file: false,
        is_receive_file: false,
        is_input: false,
        is_output: false,
        is_list_file_clients: false,
        is_list: false,
        send_filename: nil,
        port: 9876,

        key_path: ENV['KEY_PATH'] || %[#{File.dirname(__FILE__)}/../../keys/server.key],
        csr_path: ENV['CSR_PATH'] || %[#{File.dirname(__FILE__)}/../../keys/server.csr],
        crt_path: ENV['CRT_PATH'] || %[#{File.dirname(__FILE__)}/../../keys/server.crt]
      }
      methods = [
        :send_file,
        :receive_file,
        :input,
        :output,
        :list
      ]
      optparse = OptionParser.new do |opts|
        opts.banner = 'USAGE: tojour [options] name'

        opts.on('-s FILE', '--send FILE', 'Transmit a FILE.') do |filename|
          options[:is_send_file] = true
          options[:send_filename] = filename
        end

        opts.on('-r', '--receive', 'Receive a file.') do |filename|
          options[:is_receive_file] = true
          options[:receive_filename] = filename
        end

        opts.on('-i', '--input', 'Receive input and output to STOUT.') do
          options[:is_input] = true
        end

        opts.on('-o', '--output', 'Transmit output from STDIN.') do
          options[:is_output] = true
        end

        opts.on('-l', '--list-clients', 'List clients.') do
          options[:is_list] = true
        end

        opts.on('-p PORT', '--port PORT', 'Port to wait on.') do |port|
          options[:port] = port
        end

        opts.on_tail('-h', '--help', 'Show this message.') do
          STDERR.puts optparse.help
          exit
        end
      end

      @options = options
      @argv = optparse.parse(argv)
      true_values = methods.select { |name| options[:"is_#{name}"] == true }
      @method = true_values.first.to_s.gsub(/^is_/, '').to_sym
      if true_values.count != 1
        STDERR.puts optparse.help
        exit
      end
    end
  end
end

