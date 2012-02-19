
Dir.glob('*.rb').each{ |file| file = File.join( File.dirname(__FILE__), file); puts '    Loading ' + file; require file }


############################################################

#   Todo:   task :attach        # Attach to Minecraft screen
#   Todo:   task :download      # Download latest version
#   Todo:   task :list          # List online players
#   Todo:   task :status        # Gets the status of the server.
#   Todo:   task :start do      # Starts the minecraft server.
#   Todo:   task :stop do       # Stops the minecraft server.
#   Todo:   task :forceStart    # Force start
#   Todo:   task :fixScreen     # Attempts to fix issues with screen. (issue screen -w)
#   Todo:   Amazon S3 backup support
#       https://github.com/billturner/simple-s3-backup
#   Todo:   task :clean         # clean tmp etc...

############################################################
## Minecraft

def say_to_minecraft( message )
    
    #args.with_defaults(:message => "")
    if ('' == message.to_s)
        puts
        puts "'say' requires a message."
        puts 'Example:'
        puts '    rake say["Some message"]'
        puts
        exit
    end
    
    Minecraft.say_to_screen( MisemConfig.screen_name, message )
    
end

def list_players
    
end

def show_minecraft_status
    
end

def minecraft_log_tail( line_count = 6, *types )
    puts Minecraft::Log.tail( line_count, *types )
end

############################################################
## Information and debugging

def show_about
    puts
    Misem.showAboutMessage
    puts
end

def enable_debug
    $DEBUG = true
    puts '** Forced debug on'
end

def enable_verbose
    $VERBOSE = true
    puts '** Forced --verbose on'
end

def enable_trace
    Rake.application.options.trace = true
    puts '** Forced --trace on'
end


