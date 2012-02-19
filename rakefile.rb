
# rake -T       # List all tasks
# rake about    # Show about message

## Global configuration

class Misem  # Minecraft Server Manager
    
    def self.config
        
        if @@config.nil?
            @@config = new ConfigBase( {
                    # The path where the server binaries live.
                    server_path     => '/home/minecraft/server-bukkit5'
                    
                    # The path to put backups of server files.
                    backup_path     => '/home/minecraft/backups'
                    
                    # The path to put backups of the log files.
                    logs_path       => '/home/minecraft/backup/logs'
                    
                    # The path to put temporary files.
                    temp_path       => '/tmp/misem'
                    
                    # The name of the screen session to use for the server.
                    screen_name     => 'minecraft'
                    
                    jarFile         => 'craftbukkit-1.0.1-R1.jar'
                    #craftbukkit-1.1-R3.jar
                    jarMemoryMax    => '1300M'
                    jarMemoryStart  => '800M'
                    
                    # A list of worlds that will be backed up.
                    world_names     => %w(
                        adams  duck  duke  duck_nether  hyrule  hyrule_nether  hyrule_the_end
                        )
                    
                    worlds_path     => '/home/minecraft/server-bukkit5/worlds'
                    pluginsPath     => '/home/minecraft/server-bukkit5/plugins'
                    
                    # List of items to back up.
                    # Separated by any whitespace.
                    # Relative to the server_path.
                    backupExcludePaths  => %w(
                        plugins/dynmap/web/tiles
                        )
                }
        end
        
        @@config
    end
    
end

############################################################
##  End of configuration
############################################################

Dir.glob('Misem/*.rb').each{ |file| file = File.join( File.dirname(__FILE__), file); puts '    Loading ' + file; require file }

############################################################
##  Tasks

# Todo and ideas:
# rake backup:worlds    # backup all worlds
# rake backup:world[name]   # Backup named world
# rake backup           # backup everything

# rake backup
# each world  -> zip -> backup dir
# each plugin -> zip -> backup dir
# server files -> zip -> backup dir

# rake file:permissions:fix     # Changes file owner and group

#if (Application.windows?)
#    puts 'This script was not designed to run in Windows.'
#    exit
#end

#desc "(Not implemented) Backup all worlds, plugins and server files."
#task( :backup ) { backup_all }

namespace :backup do
    desc "Backup the named world."
    task( :world, %w( name ) ) { |t,a|  backup_world( a.name ) }
end

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

desc " --> sudo chown -R user:group `pwd`"
task( :chown, %w( user group ) ) { |t,a| exec 'sudo chown -R ' + a.user + ':' + a.group + ' `pwd`'

desc " --> sudo chown -R user:group `pwd`"
task( :chown, %w( permissions ) ) { |t,a| exec 'sudo chmod -R ' + permissions + ' `pwd`'

############################################################
##  Task functions

def backup_all


end

def backup_world( world_name )
    
    Misem.valid_world? world_name
    
    Minecraft.say_to_screen( Misem.config.screen_name, 'Testing world backup.' )  if Misem.config.fake?
    Minecraft.say_to_screen( Misem.config.screen_name, 'Backup of world ' + world_name + ' starting.' )
    
    FileUtils.mkdir_p Misem.config.backup_path
    
    puts 'Starting backup...'
    Minecraft.say_to_screen( Misem.config.screen_name, 'A backup of the server is starting.' )
    
    begin
        
        Minecraft.write_to_screen( Misem.config.screen_name, 'save-off' )
        Minecraft.write_to_screen( Misem.config.screen_name, 'save-all' )
        sleep(4.seconds)
        
        # Misem.test_mode?
        
    rescue
        Minecraft.say_to_screen( Misem.config.screen_name, 'Backup of world ' + world_name + ' failed.' )
    ensure
        Minecraft.write_to_screen( Misem.config.screen_name, 'save-on' )
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
    
    # Misem.config.server_path
    # Misem.config.backup_path
    # Misem.config.logs_path
    # Misem.config.screen_name
    # Misem.config.world_names
    # Misem.config.worlds_path
    # Misem.config.pluginsPath
    # Misem.config.backupExcludePaths
    
    
    Minecraft.say_to_screen( Misem.config.screen_name, 'Backup of world ' + world_name + ' complete.' )
    
end

############################################################
##  Classes
############################################################

############################################################
##  Misem main classes

class Misem  # Minecraft Server Manager
    
    def self.version;       '1.0';  end
    def self.name;          'Misem (MInecraft SErver Manager)';       end
    def self.author;        'Nathan Perry <nateperry333@gmail.com>';    end
    def self.license;       'This work is licensed under the Creative Commons Attribution 3.0 Unported License. To view a copy of this license, visit http://creativecommons.org/licenses/by/3.0/ or send a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.'; end
    
    def self.aboutMessage
        message  = "#{self.name} v#{self.version}\n"
        message += "Written by #{self.author}\n"
        message += "\n"
        message += self.license + "\n"
        message += "\n"
    end
    
    def self.valid_name?( name )
        return false if name.nil?
        return false if '' == name
        return true
    end
    
    def self.valid_world?( name )
        return false if !self.valid_name( name )
        # Todo: Validate world folder exists.
        return true
    end
    
    def self.valid_plugin?( name )
        return false if !self.valid_name( name )
        # Todo: Validate world folder exists.
        return true
    end
    
    ## Lists all tasks
    #def self.tasks()
    #    
    #    maxLengthTaskNames = Rake::Task.tasks.map{ |task| task.name.length }.max
    #    
    #    message = ''
    #    Rake::Task.tasks.each do |task|
    #        message += task.name
    #        if ( !('' == task.comment.to_s) ) # if the comment is not empty
    #            spacing = (maxLengthTaskNames - task.name.length).times.map{' '}.join
    #            message += spacing
    #            message += '  # '
    #            message += task.comment
    #        end
    #        message += "\n"
    #    end
    #    
    #    message
    #end
    
end

############################################################
##  Support classes

# Based on http://mjijackson.com/2010/02/flexible-ruby-config-objects
class ConfigBase

  def initialize(data={})
    @data = {}
    update!(data)
  end

  def update!(data)
    data.each do |key, value|
      self[key] = value
    end
  end

  def [](key)
    @data[key.to_sym]
  end

  def []=(key, value)
    if value.class == Hash
      @data[key.to_sym] = Config.new(value)
    else
      @data[key.to_sym] = value
    end
  end

  def method_missing(sym, *args)
    if sym.to_s =~ /(.+)=$/
      self[$1] = args.first
    else
      self[sym]
    end
  end

end

