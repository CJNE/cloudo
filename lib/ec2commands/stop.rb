module Ec2Commands
  class Stop < Command
    def initialize(args, options)
      @base_options = options
      @banner = "Usage: ec2 stop <identifier>"
      parse_args args 
      @instance_id = args[1]
      if !@instance_id
        puts @optparse.banner
        exit
      end
    end

    def execute(provider)
      server = get_instance provider, @instance_id 
      puts "Stopping server..."
      server.stop
    end
  end
end
