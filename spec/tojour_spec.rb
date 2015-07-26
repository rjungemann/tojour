require 'spec_helper'
require 'ostruct'

describe Tojour do
  before do
    @error_messages = []
    allow($stderr).to receive(:puts) { |msg|
      @error_messages << msg
      nil
    }
  end

  before do
    @system_commands = []
    @system_return_value = 0
    allow(Kernel).to receive(:system) { |cmd|
      @system_commands << cmd
      @system_return_value
    }
  end

  it 'has a version number' do
    expect(Tojour::VERSION).not_to be nil
  end

  describe Tojour::Utils do
    describe '.log' do
      it 'logs a return message' do
        expect(Tojour::Utils.log('Hello, world!')).to eq(nil)
        expect(@error_messages).to eq(["\e[0;94;49mHello, world!\e[0m"])
      end
    end

    describe '.sh' do
      it 'prints the command and then runs it' do
        expect(Tojour::Utils.sh('ls -al')).to eq(0)
        expect(@error_messages).to eq(["\e[0;33;49mls -al\e[0m"])
        expect(@system_commands).to eq(['ls -al'])
      end
    end
  end

  describe Tojour::Sock do
    before do
      @options = {
        key_path: 'some/path/server.key',
        crt_path: 'some/path/server.crt',
        port: 1234
      }
    end

    describe '#initialize' do
      it 'allows for a Sock object to be created' do
        sock = Tojour::Sock.new(@options)
        expect(sock.options).to eq(@options)
        expect(sock.key_path).to eq(@options[:key_path])
        expect(sock.crt_path).to eq(@options[:crt_path])
        expect(sock.port).to eq(@options[:port])
      end
    end

    describe '#server' do
      it 'allows for a server instance to be generated' do
        calls = []
        error_messages = []
        fake_ssl_server = OpenStruct.new(start_immediately: false)
        allow_any_instance_of(Tojour::Sock).to receive(:ssl_server) {
          calls << ['Tojour::Sock#ssl_server']
          fake_ssl_server
        }
        sock = Tojour::Sock.new(@options)
        actual_ssl_server = nil
        sock.server do |ssl_server|
          actual_ssl_server = ssl_server
        end
        expect(calls).to eq([['Tojour::Sock#ssl_server']])
        expect(@error_messages).to eq(["\e[0;94;49mListening on port 1234.\e[0m"])
        expect(actual_ssl_server).to eq(fake_ssl_server)
      end
    end

    describe '#client' do
      it 'allows for a client instance to be generated' do
        calls = []
        error_messages = []
        fake_ssl_client = OpenStruct.new(state: 'something')
        allow_any_instance_of(Tojour::Sock).to receive(:ssl_client) {
          calls << ['Tojour::Sock#ssl_client']
          fake_ssl_client
        }
        sock = Tojour::Sock.new(@options)
        actual_ssl_client = nil
        sock.client('someone.local', 12345) do |ssl_client|
          actual_ssl_client = ssl_client
        end
        expect(calls).to eq([['Tojour::Sock#ssl_client']])
        expect(@error_messages).to eq([])
        expect(actual_ssl_client).to eq(fake_ssl_client)
      end
    end
  end

  # TODO: Add some tests
  describe Tojour::OptParser do
  end

  # TODO: Add some tests
  describe Tojour::Jour do
  end

  # TODO: Add some tests
  describe Tojour::Cli do
  end
end

