#!/usr/bin/env ruby
require 'optparse'
require_relative '../lib/cloudo.rb'
require 'rubygems'
require 'fog'

# Find all available commands 
commands = Cloudo.constants.find_all do |item|
  !item.to_s.eql? "Command"
end
help_commands = commands.join(" ").downcase

# Parse options
options = {}
optparse = OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [options] command [index]"
  opts.separator ""
  opts.separator "Commands: " + help_commands
  opts.separator ""
  opts.separator "Options:"
  options[:verbose] = false
  opts.on('-v', '--verbose', 'Output more information') do
    options[:verbose] = true
  end
  options[:credential] = "default"
  opts.on('-c', '--credential CREDENTIAL', 'What credential to use') do |credential|
    options[:credential] = credential
  end
  options[:region] = nil
  opts.on('-r', '--region REGION','What region to use (us-east-1, eu-west-1 etc)') do |region|
    options[:region] = region
  end
  opts.on('-h', '--help', 'Display help') do
    puts opts
    exit
  end
end
optparse.order!

command = ARGV[0]
unless command && commands.include?(command.capitalize.to_sym)
  puts optparse.banner
  puts "Available commands: #{help_commands}"
  exit 1
end
command = command.capitalize.to_sym

#Set up fog
puts "Using credential #{options[:credential]}" if options[:verbose]
puts "Region: #{options[:region]}" if options[:verbose] && options[:region]
Fog::credential = options[:credential] if options[:credential]
fog_opts = { provider: 'AWS' }
fog_opts[:region] = options[:region] if options[:region]
provider= Fog::Compute.new(fog_opts)

#Execute command
klass = Cloudo.const_get(command)
klass.new(ARGV, options).execute(provider)
