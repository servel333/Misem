# Misem         # Minecraft Server Manager
# rake -T       # List what this script can do.

screen_name  = 'minecraft'
memory_max   = '1300M'
memory_start = '800M'
server_jar_file = 'craftbukkit-1.1-R4.jar'

############################################################
##  Tasks
############################################################

task :default => [ :help, :info ]

desc "Connect to the Minecraft screen"
task( :c ) { puts_exec 'screen -r minecraft' }

desc "Show the last 20 [INFO] lines from the log"
task( :info ) { cd_invoked_dir; puts_exec 'cat server.log | grep \\[INFO\\] | tail -20' }

desc "Show log-ins"
sed_in = ' -e "s/ \[INFO\] \([^ ]*\) lost connection[:] disconnect[.]quitting/ -- \1/p" '
task( :in ) { cd_invoked_dir; puts_exec( 'sed -n ' + sed_in + ' server.log | tail -20' ) }

desc "Show log-outs"
sed_out = ' -e "s/ \[INFO\] \([^ ]*\) \[\/\([0-9:.]*\)\] logged in with entity id \([0-9]*\).*/ ++ \1  \2  entity id \3/p" '
task( :out ) { cd_invoked_dir; puts_exec( 'sed -n ' + sed_out + ' server.log | tail -20' ) }

desc "Show log-ins and log-outs from the log"
task( :io ) { cd_invoked_dir; puts_exec( 'sed -n ' + sed_in + sed_out + '  server.log | tail -20' ) }

desc "tail -20 server.log"
task( :tail ) { cd_invoked_dir; puts_exec 'tail -20 server.log' }

desc "Show a count of the number of 'server overloaded' lines in the log"
task( :ol? ) { cd_invoked_dir; puts_exec 'sed -n  -e "s/\[WARNING\] Can\'t keep up! Did the system time change, or is the server overloaded\?//p" server.log | sed -n \'$=\'' }

# SERVER_PATH=/home/minecraft/server-bukkit5
# SCREEN_NAME="minecraft"
# DISPLAY_ON_LAUNCH=1

# LOGS_PATH=/home/minecraft/backup/logs
# LOGS_DAYS=7

desc "Start the server"
task( :start ) do
    cd_invoked_dir
    puts_exec 'screen -m -d -S ' + screen_name + 
            ' java ' + 
            ' -Xmx' + memory_max + 
            ' -Xms' + memory_start + 
            ' -XX:ParallelGCThreads=2 ' + 
            ' -Djava.net.preferIPv4Stack=true ' + 
            ' -jar ' + server_jar_file + 
            ' nogui; sleep 1'
end

############################################################
##  Utility
############################################################

def puts_exec( *command )
  puts *command
  exec *command
end

def cd_invoked_dir
  cd  Rake.application.original_dir
end
