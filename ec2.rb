#!/usr/bin/env ruby
$LOAD_PATH << './lib'
require 'ec2command.rb'
command = ARGV[0]
instance = Ec2Command.new
instance.send(command)
