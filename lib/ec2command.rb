require 'rubygems'
require 'fog'
require 'active_support'

class Ec2Command
  def initialize(options, args)
    @args = args
    @options = options
    Fog::credential = options[:credential] if options[:credential]
    fog_opts = { provider: 'AWS' }
    fog_opts[:region] = options[:region] if options[:region]
    @provider= Fog::Compute.new(fog_opts)
  end

  def method_missing(m, *args, &block)
    raise "There's no such command: #{m}."
  end

  # Parse the instance option and return the maching instance from the provider.
  # If numeric fetch all and select corresponding index from result array, otherwise select the instance tagged
  #
  def parse_instance
    raise "No index/name paramter given, use the list command to find out what index paramter to use or specify the instance name" if @args[1].nil?
    server = nil
    if is_numeric? @args[1]
      index = @args[1].to_i - 1
      server = @provider.servers.all[index] 
    else
      server = @provider.servers.all('tag:Name' => @args[1])[0]
    end
    server
  end
  def _find(name)
    @servers.select {|s| s.tags["Name"].include? name}
  end
  def ssh
    server = parse_instance
    system("ssh -i ~/.ssh/#{server.key_name} #{ARGV[2]}@#{server.public_ip_address}")
  end
  def show
    server = parse_instance
    puts server.inspect
  end
  def start
    server = parse_instance
    puts "Starting instance #{server.id}"
    server.start
  end
  def stop
    server = parse_instance
    puts "Stopping instance #{server.id}"
    server.stop
  end
  def find
    server = _find(@args[1])[0]
    puts server.inspect
  end
  def list
    index = 1
    @provider.servers.all.each do |server| 
      name = server.tags["Name"] || server.id
      puts "[#{index}] #{name} ID: #{server.id} State: #{server.state} DNS: #{server.dns_name}"
      index += 1
    end
  end
  private
  def is_numeric?(obj) 
    obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
  end
end
