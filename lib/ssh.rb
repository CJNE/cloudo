class Ssh
  def initialize(options)
    parse_options options
  end

  def help
    "Start a SSH session to the instance"
  end
  protected
  #Possible options user@instanse, or user@n 
  def parse_options argv
    @options = {}
    optparse = OptionParser.new do |opts|
      opts.banner = "Usage: ec2 ssh [options] [user@]target"
      opts.on('-t', '--tmux') do
        @options[:tmux] = true
      end
      opts.on_tail('-h', '--help', 'Display help') do
        puts opts
        exit
      end
    end
    optparse.parse!(argv)
    if !argv[1]
      puts optparse.banner
      exit
    end
    puts argv[1]
  end
end
