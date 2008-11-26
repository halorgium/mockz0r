require 'rubygems'
require 'spec'

require File.dirname(__FILE__) + '/../lib/slice'
require File.dirname(__FILE__) + '/../lib/mysql_server'

class MockSlice
  def initialize
    @installs = [MysqlInstall.new]
  end

  def run(command)
    i, m = find_install(command)
    raise "Unhandled command: #{command}" unless m
    i.send(m, command)
  end

  def find_install(command)
    @installs.each do |i|
      m = i.locate(command)
      return [i, m] if m
    end
  end

  def self.matches
    @matches ||= []
  end

  def self.match(regex, &block)
    matches << [regex, block]
  end

  class MysqlInstall
    def initialize
      @mysql_dbs = []
    end

    def locate(command)
      case command
      when /\/mysql_install /
        :install
      when /\/mysql_list /
        :list
      when /\/mysql_create /
        :create
      when /\/mysql_rm /
        :remove
      end
    end

    def install(command)
      @mysql_dbs = ["mysql"]
      "installed"
    end

    def list(command)
      @mysql_dbs.join("\n")
    end

    def create(command)
      if command =~ /mysql_create [^ ]+ (\w+)$/
        @mysql_dbs << $1
        "created"
      else
        "FAILED"
      end
    end

    def remove(command)
      if command =~ /mysql_rm [^ ]+ (\w+)$/
        @mysql_dbs.delete($1)
        "removed"
      else
        "FAILED"
      end
    end
  end
end
