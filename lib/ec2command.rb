require 'rubygems'
require 'fog'
require 'active_support'

class Ec2Command
  def initialize(options, args)
    @args = args
    Fog::credential = options[:credential] if options[:credential]
    fog_opts = { provider: 'AWS' }
    fog_opts[:region] = options[:region] if options[:region]
    @provider= Fog::Compute.new(fog_opts)
    @index = options[:index] || 0
    @servers = options[:name] ? @provider.servers.all('tag:Name' => options[:name]) : @provider.servers 
  end
  def parse_index
    @args[1].to_i - 1
  end
  def method_missing(m, *args, &block)
    puts "There's no method called #{m} here -- please try again."
  end
  def _find(name)
    @servers.select {|s| s.tags["Name"].include? name}
  end
  def ssh
    index = parse_index
    server = @servers[index]
    system("ssh -i ~/.ssh/#{server.key_name} #{ARGV[2]}@#{server.public_ip_address}")
  end
  def show
    index = parse_index
    puts @servers[index].inspect
  end
  def find
    server = _find(@args[1])[0]
    puts server.inspect
  end
  def list
    index = 1
    @servers.each do |server| 
      name = server.tags["Name"] || server.id
      puts "[#{index}] #{name} #{server.dns_name}"
      index += 1
    end
  end
end
