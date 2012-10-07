#!/usr/bin/env ruby
$LOAD_PATH << './lib'
require 'optparse'
require 'ec2command.rb'
options = {}
optparse = OptionParser.new do |opts|
  opts.banner = "Usage: ec2.rb [options] command [index]"
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
  options[:name] = nil
  opts.on('-n', '--name NAME', 'Operate on instance with tag Name = NAME') do |name|
    options[:name] = name
  end
  opts.on_tail('-h', '--help', 'Display help') do
    puts opts
    exit
  end
end
optparse.parse!
command = ARGV[0]
if( !command) then
  puts optparse.banner
  exit 1
end

puts "Using credential #{options[:credential]}" if options[:verbose]
puts "Region: #{options[:region]}" if options[:verbose]
begin
  instance = Ec2Command.new options, ARGV
  instance.send(command)
rescue
  puts $!
  puts optparse.banner
  exit 1
end
