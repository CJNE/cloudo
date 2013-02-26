module Cloudo
  class Ssh < Command
    def initialize(args, options)
      @base_options = options
      @banner = "Usage: cloudo ssh [options] [user@]identifier"
      @ssh_options = {
        :use_password => false,
        :key => ''
      }
      parse_args args do |opts|
        opts.on('-k', '--key KEY',
               'Path to the ssh private key to use, defaults to the server key name attribute') do |key|
          @ssh_options[:key] = key
        end
        opts.on('-p', '--password', "Use password authentication") do
          @ssh_options[:use_password] = true
        end
        opts.on('-t', '--tmux', "Start session in a new tmux buffer") do
          @ssh_options[:tmux] = true
        end
      end
      @instance_id = args[1]
      if !@instance_id
        puts @optparse.banner
        exit
      end
      if parts = @instance_id.match('(.+@)(.+)')
        @user = parts[1]
        @instance_id = parts[2]
      end
    end

    def execute(provider)
      server = get_instance provider, @instance_id 
      exe = "ssh "
      if @ssh_options[:key].length > 0
        exe << "-i #{@ssh_options[:key]} "
      elsif !@ssh_options[:use_password]
        puts "nay"
        exe << "-i .ssh/#{server.key_name} "
      end
      exe << "#{@user}#{server.public_ip_address}"
      system exe
    end
  end
end
