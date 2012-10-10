module Cloudo
  class Show < Command
    def initialize(args, options)
      @base_options = options
      @banner = 'Usage: cloudo show [options]'
      parse_args args
      @instance_id = args[1]
    end
    def execute(provider)
      server = get_instance provider, @instance_id
      puts "Id:          #{server.id}"
      puts "Name:        #{server.tags['Name']}"
      puts "State:       #{server.state}"
      puts "Zone:        #{server.availability_zone}"
      puts "Type:        #{server.flavor_id}"
      puts ""
      puts "Public DNS:  #{server.dns_name}"
      if @base_options[:verbose]
        puts ""
        puts "Public IP:        #{server.public_ip_address}"
        puts "Private IP:       #{server.private_ip_address}"
        puts "Security groups:  #{server.groups}"
        puts "Key name:         #{server.key_name}"
        puts "Image:            #{server.image_id}"
        puts "Kernel:           #{server.kernel_id}"
      end
    end
  end
end
