module Ec2Commands
  class Command
    def initialize(options)
      parse_args options
    end

    def parse_args(args, &block)
      @options = {}
      @optparse = OptionParser.new do |opts|
        opts.banner = @banner
        yield(opts) if block
        opts.on_tail('-h', '--help', 'Display help') do
          puts opts
          exit
        end
      end
      @optparse.parse!(args)
    end
    def get_instance(provider, instance_id)
      raise "No index/name paramter given, use the list command to find out what index paramter to use or specify the instance name" if instance_id.nil?
      server = nil
      if is_numeric? instance_id
        index = instance_id.to_i - 1
        server = provider.servers.all[index]
      else
        server = provider.servers.all('tag:Name' => instance_id)[0]
      end
      server
    end
    private
    def is_numeric?(obj) 
      obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
    end
  end
end
