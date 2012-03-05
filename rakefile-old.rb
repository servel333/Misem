# Misem         # Minecraft Server Manager
# rake -T       # List what this script can do.

############################################################
##  Configuration
############################################################

class Misem
    def self.config     ## Global configuration
        @@config ||= new ConfigBase( {
        
            # The path where the server binaries live.
            #'server_path'     => '/home/minecraft/server-bukkit5',
            'server_path'       => 'ignore\server-bukkit5',
            
            # The path to put backups of server files.
            #'backup_path'     => '/home/minecraft/backups',
            'backup_path'       => 'ignore/backup'
            
            # The path to put backups of the log files.
            'logs_path'       => '/home/minecraft/backup/logs',
            
            # The path to put temporary files.
            'temp_path'       => '/tmp/misem',
            
            # The name of the screen session to use for the server.
            'screen_name'     => 'minecraft',
            
            'jarFile'         => 'craftbukkit-1.0.1-R1.jar',
            #craftbukkit-1.1-R3.jar
            'jarMemoryMax'    => '1300M',
            'jarMemoryStart'  => '800M',
            
            # A list of worlds that will be backed up.
            'world_names'     => %w(
                adams  duck  duke  duck_nether  hyrule  hyrule_nether  hyrule_the_end
                ),
            
            'worlds_path'     => '/home/minecraft/server-bukkit5/worlds',
            'plugins_path'     => '/home/minecraft/server-bukkit5/plugins',
            
            # List of items to back up.
            # Separated by any whitespace.
            # Relative to the server_path.
            'backupExcludePaths'  => %w(
                plugins/dynmap/web/tiles
                ),
        } )
        
        @@config
    end
end

##  End of configuration

############################################################
##  Tasks
############################################################

task :default => [ :help, :info ]

############################################################
##  Server screen management

desc "Connect to the Minecraft screen"
task( :c ) { puts_exec 'screen -r minecraft' }

############################################################
##  Log management

desc "Show [INFO] lines from the log"
task( :info ) { cd_invoked_dir; puts_exec 'cat server.log | grep \\[INFO\\] | tail' }

desc "Show log in and log out messages"
task( :l ) { cd_invoked_dir; puts_exec 'cat server.log | grep "logged in with entity id" | tail' }

desc "tail -20 server.log"
task( :tail ) { cd_invoked_dir; puts_exec 'tail -20 server.log' }







# Todo and ideas:
#
# rake backup               # backup each
# rake backup:world[name]   # Backup named world
# rake backup:worlds        # backup all worlds
# rake cmd["COMMAND"]       # write COMMAND to the server console
# rake info                 # show server statistics
# rake say["MESSAGE"]       # write say MESSAGE to the server console
# rake show:chat            # show the last DEFAULT lines of chat
# rake show:chat[all]       # show the entire chat log
# rake show:chat[NUM]       # show last NUM lines of chat from the log
# rake show:log             # show the last DEFAULT lines from the log
# rake show:log[all]        # show the entire log
# rake show:log[NUM]        # show last NUM lines in the log
# rake show:players         # show a list of players on the server
# rake file:permissions:fix     # Changes file owner and group

#desc "Backup all worlds, plugins and server files."
#task( :backup ) { backup_all }

#namespace :backup do
#    desc "Backup the named world."
#    task( :world, %w( name ) ) { |t,a|  backup_world( a.name ) }
#    desc "Backup the named plugin."
#    task( :plugin, %w( name ) ) { |t,a|  backup_plugin( a.name ) }
#end

desc "Speaks the message into the server chat."
task( :say, %w( message ) ) { |t,a| say_to_minecraft( a.message ) }

task( :info ) { show_info }

namespace :server do
    task( :status ) { show_minecraft_status }
    task( :list   ) { list_players }
end

task  :log  =>  %w(  log:tail  )

namespace :log do
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
task( :about ) { show_about }

desc 'Enables debugging and verbose output.'
task :debug  =>  %w(  options:debug  options:verbose  )

# For testing what I am currently working on.
task  :test  =>  %w(  options:debug  options:verbose  )  do
    ClassUnitTests.run
end

desc " --> sudo chown -R user:group working_dir"
task( :chown, %w( user group ) ) { |t,a| exec 'sudo chown -R ' + a.user + ':' + a.group + ' ' + Rake.application.original_dir }

desc " --> sudo chmod -R user:group working_dir"
task( :chmod, %w( permissions ) ) { |t,a| exec 'sudo chmod -R ' + permissions + ' ' + Rake.application.original_dir }

############################################################
##  Task functions
############################################################

def backup_all
    
    #Dir.foreach('/path/to/dir') do |item|
    #    next if item == '.' or item == '..'
    #    # do work on real items
    #end

    # each world => backup + compress
    # each plugin => backup + compress
    # log file

end

def backup_world( world_name )
    
    Misem.test_world  world_name
    
    Minecraft.say_to_screen( Misem.config.screen_name, 'Backup of world ' + world_name + ' starting.' )
    
    FileUtils.mkdir_p  File.join( Misem.config.backup_path, )
    
    puts 'Starting backup...'
    Minecraft.say_to_screen( Misem.config.screen_name, 'A backup of the server is starting.' )
    
    begin
        
        Minecraft.write_to_screen( Misem.config.screen_name, 'save-off' )
        Minecraft.write_to_screen( Misem.config.screen_name, 'save-all' )
        sleep(4.seconds)
        
        source = File.join( Misem.config.worlds_path, name )
        destination = File.join( Misem.config.backup_path, name + '.zip' )
        
        #minecraft\server-bukkit5\worlds
        # backup_path/date/
        
    rescue
        Minecraft.say_to_screen( Misem.config.screen_name, 'Backup of world ' + world_name + ' failed.' )
    ensure
        Minecraft.write_to_screen( Misem.config.screen_name, 'save-on' )
    end
    
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
    # Misem.config.plugins_path
    # Misem.config.backupExcludePaths
    
    Minecraft.say_to_screen( Misem.config.screen_name, 'Backup of world ' + world_name + ' complete.' )
    
end

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

def show_info

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

#if (Application.windows?)
#    puts 'This script was not designed to run in Windows.'
#    exit
#end

############################################################
##  Utility
############################################################

def check_string
    
end

def puts_exec( *command )
  puts *command
  exec *command
end

def cd_invoked_dir
  cd  Rake.application.original_dir
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
    
    def self.test_world( name )
        raise 'No world was named.'  if !self.valid_name  name
        raise 'World folder missing.'  if File.exists? File.join( Misem.config.worlds_path, name )
    end
    
    def self.test_plugin( name )
        raise 'No plugin was named.'  if !self.valid_name  name
        #raise 'Plugin missing.'  if File.exists? File.join( Misem.config.plugins_path, name )
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

