#!/usr/bin/env ruby
#
require 'rubygems'
require 'fog'
require 'active_support'

class Ec2Command
    def initialize()
        @provider= Fog::Compute.new(:provider => 'AWS')
        @servers = ARGV[1].nil? ? @provider.servers : @provider.servers.all('tag:Name' => ARGV[1])
    end
    def method_missing(m, *args, &block)
        puts "There's no method called #{m} here -- please try again."
    end
    def _find(name)
        @servers.select {|s| s.tags["Name"].include? name}
    end
    def ssh
        server = @servers[0]
        exec = ""
        if ARGV[3]
            exec = "\"#{ARGV[3]}\"" 
        end
        system("ssh -i ~/.ssh/#{server.key_name} #{ARGV[2]}@#{server.public_ip_address} #{exec}")
    end
    def show
        puts @servers[0].inspect
    end
    def find
        server = _find(ARGV[1])[0]
        puts server.inspect
    end
    def list
        @servers.each do |server| 
            name = server.tags["Name"] || server.id
            puts name
        end
    end
end
command = ARGV[0]
instance = Ec2Command.new
instance.send(command)
