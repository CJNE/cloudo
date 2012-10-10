module Ec2Commands
  class Start < Command
    def initialize(args, options)
      @base_options = options
      @banner = "Usage: ec2 start <identifier>"
      parse_args args 
      @instance_id = args[1]
      if !@instance_id
        puts @optparse.banner
        exit
      end
    end

    def execute(provider)
      server = get_instance provider, @instance_id 
      puts "Starting server..."
      server.start
    end
  end
end
