
Dir.glob('Misem/*.rb').each{ |file| require file }

class Misem
    
    def self.version;       '1.0';  end
    def self.name;          'Misem (MInecraft SErver Manager)';       end
    def self.author;        'Nathan Perry <nateperry333@gmail.com>';    end
    def self.license;       'This work is licensed under the Creative Commons Attribution 3.0 Unported License. To view a copy of this license, visit http://creativecommons.org/licenses/by/3.0/ or send a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.'; end
    
    def self.tasks()
        
        maxLengthTaskNames = Rake::Task.tasks.map{ |task| task.name.length }.max
        
        message = ''
        Rake::Task.tasks.each do |task|
            message += task.name
            if ( !('' == task.comment.to_s) ) # if the comment is not empty
                spacing = (maxLengthTaskNames - task.name.length).times.map{' '}.join
                message += spacing
                message += '  # '
                message += task.comment
            end
            message += "\n"
        end
        
        message
    end
    
    def self.showTasks()
        puts '{', self.tasks.indent, '}'
    end
    
    def self.aboutMessage
        message  = "#{self.name} v#{self.version}\n"
        message += "Written by #{self.author}\n"
        message += "\n"
        message += self.license + "\n"
        message += "\n"
    end
    
    def self.showAboutMessage
        puts self.aboutMessage
    end
    
end

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


