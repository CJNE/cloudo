module Ec2Commands
  class Show < Command
    def initialize(args)
      @banner = 'Usage: ec2 show [options]'
      parse_args args
      @instance_id = args[1]
    end
    def execute(provider)
      server = get_instance provider, @instance_id
      puts server.inspect
    end
  end
end
