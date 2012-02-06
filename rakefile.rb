
class MisemConfig  # Minecraft Configuration
    
    # The path where the server binaries live.
    def self.serverPath;    '/home/minecraft/server-bukkit5';   end
    
    # The path to put backups of server files.
    def self.backupPath;    '/home/minecraft/backups';          end
    
    # The path to put backups of the log files.
    def self.logsPath;      '/home/minecraft/backup/logs';      end
    
    # The name of the screen session to use for the server.
    def self.screenName;    'minecraft';    end
    
    def self.jarFile;       'craftbukkit-1.0.1-R1.jar';         end
    def self.jarMemoryMax;      '1300M';    end
    def self.jarMemoryStart;    '800M';     end
    
    # A list of worlds that will be backed up.
    def self.worldNames;    %w(
        adams  duck  duke  duck_nether  hyrule  hyrule_nether  hyrule_the_end
        );   end
    
    def self.worldsPath;    '/home/minecraft/server-bukkit5/worlds';    end
    def self.pluginsPath;   '/home/minecraft/server-bukkit5/plugins';   end
    
    # List of items to back up.
    # Separated by any whitespace.
    # Relative to the serverPath.
    def self.backupExcludePaths;   %w(
        plugins/dynmap/web/tiles
        );   end
    
end

############################################################
## End of configuration
############################################################

class Misem
    
    def self.version;   '1.0';  end
    def self.name;      'Misem (MInecraft SErver Manager)';       end
    def self.author;    'Nathan Perry <nateperry333@gmail.com>';    end
    def self.license;   'This work is licensed under the Creative Commons Attribution 3.0 Unported License. To view a copy of this license, visit http://creativecommons.org/licenses/by/3.0/ or send a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.'; end
    
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
    
end

############################################################
##  Tasks

#if (Application.windows?)
#    puts 'This script was not designed to run in Windows.'
#    exit
#end

desc 'Task run when no task is specified.'
task :default => [ :help, :status ]

desc 'For testing what I am currently working on.'
task :test do
    
end

desc 'Displays help.'
task :help do
    puts
    puts "Available tasks:"
    Misem.showTasks
    puts "Examples: "
    puts sayExample().indent
    puts
    Misem.showAboutMessage
    puts
end

task :about do
    puts
    Misem.showAboutMessage
    puts
end

desc 'Speaks the message into the server chat.'
task :say, [ :message ] do |t, args|
    
    message = args[ :message ]
    
    #args.with_defaults(:message => "")
    if ('' == message.to_s)
        puts
        puts "'say' requires a message."
        puts 'Example:'
        puts '    rake say["Some message"]'
        puts
        exit
    end
    
    Minecraft.sayToScreen( MisemConfig.screenName, message )
    
end


desc 'Runs a backup of server files.'
task :backup do
    
    FileUtils.mkdir_p MisemConfig.backupPath
    
    puts 'Starting backup...'
    Minecraft.sayToScreen( MisemConfig.screenName, 'A backup of the server is starting.' )
    
    begin
    
        Minecraft.writeToScreen( MisemConfig.screenName, 'save-off' )
        Minecraft.writeToScreen( MisemConfig.screenName, 'save-all' )
        sleep(4.seconds)
        
    rescue
    ensure
        Minecraft.writeToScreen( MisemConfig.screenName, 'save-on' )
    end
    
    
    #Dir.foreach('/path/to/dir') do |item|
    #    next if item == '.' or item == '..'
    #    # do work on real items
    #end
    
    
    # each world => backup + compress
    # each plugin => backup + compress
    # log file
    
    # MINECRAFTDIR="/home/minecraft/server-bukkit5"
    # BACKUPDIR="/home/minecraft/backups/server-bukkit5"
    # BACKUPDATE=`date +%Y-%m-%d`
    # FINALDIR="/home/minecraft/backups/server-bukkit5/`date +%Y-%m-%d`"
    # BFILE="3-`date +%Y-%m-%d-%Hh%M-%S`.tar.gz"
    # CMD="tar -czf $FINALDIR/$BFILE $MINECRAFTDIR"
    
    # MisemConfig.serverPath
    # MisemConfig.backupPath
    # MisemConfig.logsPath
    # MisemConfig.screenName
    # MisemConfig.worldNames
    # MisemConfig.worldsPath
    # MisemConfig.pluginsPath
    # MisemConfig.backupExcludePaths
    
end


############################################################
##  Utilities


class Minecraft
    
    # Todo: Make most of these methods instance methods.
    #attr_accessor :screenName, :serverPath
    
    def self.writeToScreen( screenName, message )
        Console.writeToScreen( screenName, "#{message}\r" )
    end
    
    def self.sayToScreen( screenName, message )
        Console.writeToScreen( screenName, "say #{message}\r" )
    end
    
    def self.serverPropertiesFile;  'server.properties';    end
    
    def self.allow_nether;      self.getServerProperty( 'allow-nether' );   end     # true | false
    def self.level_name;        self.getServerProperty( 'level-name' );     end     # string
    def self.enable_query;      self.getServerProperty( 'enable-query' );   end     # true | false
    def self.allow_flight;      self.getServerProperty( 'allow-flight' );   end     # true | false
    def self.server_port;       self.getServerProperty( 'server-port' );    end     # number
    def self.enable_rcon;       self.getServerProperty( 'enable-rcon' );    end     # true | false
    def self.level_seed;        self.getServerProperty( 'level-seed' );     end     # string
    def self.server_ip;         self.getServerProperty( 'server-ip' );      end     # string
    def self.white_list;        self.getServerProperty( 'white-list' );     end     # true | false
    def self.spawn_animals;     self.getServerProperty( 'spawn-animals' );  end     # true | false
    def self.online_mode;       self.getServerProperty( 'online-mode' );    end     # true | false
    def self.pvp;               self.getServerProperty( 'pvp' );            end     # true | false
    def self.difficulty;        self.getServerProperty( 'difficulty' );     end     # number
    def self.server_name;       self.getServerProperty( 'server-name' );    end     # string
    def self.gamemode;          self.getServerProperty( 'gamemode' );       end     # number
    def self.max_players;       self.getServerProperty( 'max-players' );    end     # number
    def self.spawn_monsters;    self.getServerProperty( 'spawn-monsters' ); end     # true | false
    def self.view_distance;     self.getServerProperty( 'view-distance' );  end     # number
    def self.motd;              self.getServerProperty( 'motd' );           end     # string
    
    # Limitation: Expects to be in the server root directory.
    def self.getServerProperty( name )
        
        File.open( self.serverPropertiesFile ).lines.map{ |line|
            
            if ( line.match( /^\s*#/ ) )
                # Skip comments
            elsif ( line.match( /^\s*#{name}=/ ) )
                return line.gsub( /^\s*#{name}=/, '\1' )
            end
        }
        
    end
    
    # require 'yaml'
    # refs = open('FILE.yml') {|f| YAML.load(f) }
    # refs['PATH'].each do |ITEM|
    # end
    
end

class Bukkit < Minecraft
    
end

class Console
    
    # Writes the message to the named screen
    # newline characters are not appended to the message.
    def self.writeToScreen( screenName, message )
        %x(screen -x #{screenName} -X stuff "`printf "#{message}"`")
    end
    
    def self.attachToScreen( screenName )
        %x(screen -r #{screenName})
    end
    
    def self.wipeScreens()
        %x(screen -wipe)
    end
    
end

class Misem
    
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

class Utils
    
    @@_timestamp = Time.now.getlocal.strftime( '%Y_%m_%dT%H_%M_%S%z' )
    def self.timestamp;     @@_timestamp;       end
    
    def self.tar( path = '' )
        
        if ( '' == path )
            
        end
        
        if ( File.directory? path )
            
        end
        
        # MINECRAFTDIR="/home/minecraft/server-bukkit5"
        # BACKUPDIR="/home/minecraft/backups/server-bukkit5"
        # BACKUPDATE=`date +%Y-%m-%d`
        # FINALDIR="/home/minecraft/backups/server-bukkit5/`date +%Y-%m-%d`"
        # BFILE="3-`date +%Y-%m-%d-%Hh%M-%S`.tar.gz"
        # CMD="tar -czf $FINALDIR/$BFILE $MINECRAFTDIR"
        
    end
    
end

class String
    
    def indent( indentWith = '    ' )
        self.lines.map{ |item| indentWith + item }.join
    end
    
end
