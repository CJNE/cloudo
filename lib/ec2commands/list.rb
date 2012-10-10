module Ec2Commands
  class List < Command
    def initialize(args, options)
      @base_options = options
      @banner = "Usage: ec2 list [options]"
      parse_args args do |opts|
        @options['colors'] = true
        opts.on('-c', '--color', 'Display colors (default)') do
          @options['colors'] = true
        end
        opts.on('-p', '--plain', 'Display plain list (no colors)') do
          @options['colors'] = false
        end
      end
    end

    def execute(provider)
      index = 1
      provider.servers.all.each do |server| 
        print_server server, index
        index += 1
      end
    end
    
    def print_server(server, index)
      name = server.tags["Name"] || server.id
      puts "[#{index.to_s.rjust 3}] #{server.id} #{name.ljust 20} #{server.state.ljust 10} #{server.dns_name}"
    end
  end
end
