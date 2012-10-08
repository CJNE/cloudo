require 'command'
class Ssh < Command
  def initialize(args)
    @banner = "Usage: ec2 ssh [options] [user@]identifier"
    parse_args args do |opts|
      opts.on('-t', '--tmux') do
        @options[:tmux] = true
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
    exe = "ssh -i ~/.ssh/#{server.key_name} #{@user}#{server.public_ip_address}"
    puts exe
    #system exe
  end
end
