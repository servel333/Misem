
# List tasks
#       rake -T
# Show about
#       rake about

class MisemConfig  # Minecraft Configuration
    
    # The path where the server binaries live.
    def self.server_path;    '/home/minecraft/server-bukkit5';   end
    
    # The path to put backups of server files.
    def self.backup_path;    '/home/minecraft/backups';          end
    
    # The path to put backups of the log files.
    def self.logs_path;      '/home/minecraft/backup/logs';      end
    
    # The path to put temporary files.
    def self.temp_path;     '/tmp/misem';       end
    
    # The name of the screen session to use for the server.
    def self.screen_name;    'minecraft';    end
    
    def self.jarFile;       'craftbukkit-1.0.1-R1.jar';         end
    #craftbukkit-1.1-R3.jar
    def self.jarMemoryMax;      '1300M';    end
    def self.jarMemoryStart;    '800M';     end
    
    # A list of worlds that will be backed up.
    def self.world_names;    %w(
        adams  duck  duke  duck_nether  hyrule  hyrule_nether  hyrule_the_end
        );   end
    
    def self.worlds_path;    '/home/minecraft/server-bukkit5/worlds';    end
    def self.pluginsPath;   '/home/minecraft/server-bukkit5/plugins';   end
    
    # List of items to back up.
    # Separated by any whitespace.
    # Relative to the server_path.
    def self.backupExcludePaths;   %w(
        plugins/dynmap/web/tiles
        );   end
    
end

############################################################
## End of configuration
############################################################

Dir.glob('Misem/*.rb').each{ |file| require file }

############################################################
##  Tasks

#if (Application.windows?)
#    puts 'This script was not designed to run in Windows.'
#    exit
#end

namespace :server do
    desc "Speaks the message into the server chat."
    task :say, [  :message  ] do
        say_to_minecraft( args[ :message ] )
    end
    task :status do
        show_minecraft_status
    end
    task :list do
        list_players
    end
end

# rake log:chat:tail
# rake log:tail
# rake log:info:tail

task  :log  =>  %w(  log:tail  )

namespace :log do
    #desc ""
    desc "Shows the last 6 lines of the server log with non-chat filtered out."
    task :tail, [ :line_count ]  do  |task, line_count|
        minecraft_log_tail( line_count, :chat )
    end
end

namespace :options do
    task :debug do
        enable_debug
    end
    task :verbose do
        enable_verbose
    end
end

desc "Information about this script."
task :about do
    show_about
end

desc 'Task run when no task is specified.'
task :default => [ :help, :status ]

desc 'Enables debugging and verbose output.'
task :debug  =>  %w(  options:debug  options:verbose  )

# For testing what I am currently working on.
task  :test  =>  %w(  options:debug  options:verbose  )  do
    ClassUnitTests.run
end



desc 'Runs a backup of server files.'
task :backup do
    
    Minecraft.say_to_screen( MisemConfig.screen_name, 'This is a test of a new backup system.' )  if Misem.test_mode?
    
    FileUtils.mkdir_p MisemConfig.backup_path
    
    puts 'Starting backup...'
    Minecraft.say_to_screen( MisemConfig.screen_name, 'A backup of the server is starting.' )
    
    begin
        
        Minecraft.write_to_screen( MisemConfig.screen_name, 'save-off' )
        Minecraft.write_to_screen( MisemConfig.screen_name, 'save-all' )
        sleep(4.seconds)
        
        # Misem.test_mode?
        
    rescue
    ensure
        Minecraft.write_to_screen( MisemConfig.screen_name, 'save-on' )
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
    
    # MisemConfig.server_path
    # MisemConfig.backup_path
    # MisemConfig.logs_path
    # MisemConfig.screen_name
    # MisemConfig.world_names
    # MisemConfig.worlds_path
    # MisemConfig.pluginsPath
    # MisemConfig.backupExcludePaths
    
end
