require 'colorize'

module Tojour
  class Utils
    def self.log(msg)
      $stderr.puts(msg.colorize(:light_blue))
    end

    def self.sh(cmd)
      $stderr.puts(cmd.colorize(:yellow))
      Kernel.system(cmd)
    end
  end
end

