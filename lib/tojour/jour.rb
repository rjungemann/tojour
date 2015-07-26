require 'dnssd'

module Tojour
  class Jour
    def initialize(name, kind)
      @name = name
      @protocol = "_tojour_#{kind}._tcp"
    end

    def register(port, &block)
      DNSSD::register(@name, @protocol, nil, port) do |r|
        block.call(r)
      end
      loop do
        sleep 1
      end
    end

    def resolve(&block)
      DNSSD.resolve(@name, @protocol, 'local') do |r|
        block.call(r)
      end
      loop do
        sleep 1
      end
    end

    def self.list(&block)
      %w[file io].each do |kind|
        DNSSD.browse("_tojour_#{kind}._tcp") do |r|
          block.call(kind, r.name)
        end
      end
      sleep 5
    end
  end
end

