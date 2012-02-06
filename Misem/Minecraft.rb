
# Minecraft related functionality.
class Minecraft
    
    def self.write_to_screen( screen_name, message )
        Console.write_to_screen( screen_name, "#{message}\r" )
    end
    
    def self.say_to_screen( screen_name, message )
        Console.write_to_screen( screen_name, "say #{message}\r" )
    end
    
    def self.backup_map
    
    end
    
end

namespace :Minecraft do
    class ServerProperties
        
        def self.file;  'server.properties';    end
        
        def self.list
            %w(
                allow-nether
                level-name
                enable-query
                allow-flight
                server-port
                enable-rcon
                level-seed
                server-ip
                white-list
                spawn-animals
                online-mode
                pvp
                difficulty
                server-name
                gamemode
                max-players
                spawn-monsters
                view-distance
                motd
            )
        end
        
        def [](key)
            prop(key)
        end

        def method_missing(sym, *args)
            self[sym]
        end
        
        private
        
        # parses the server.properties file for the named property.
        # Limitation: Expects to be in the server root directory.
        def self.prop( name )
            
            File.open( file ).lines.map do |line|
                if ( line.match( /^ \s* # /x ) )    # comment
                elsif ( line.match( /^ \s* #{name} = /x ) )
                    return line.gsub( /^ \s* #{name} = /x, '\1' )
                end
            end
            
        end
        
    end
    class Log
        def self.file; 'server.log'; end
        def self.lock_file; 'server.log.lck'; end
        #def self.split_log
        #    log_file_io = File.new( file )
        #    log_file_io.lines.each do |line|
        #        
        #        
        #        if line.match( /^ #{ player_chat_pattern } $/x, '' )
        #            append_to_log( $~[1], $~[2]], $~[3] )
        #        end
        #    end
        #    files.inject { |nil, open_file| open_file.flush; open_file.close }
        #end
        def self.tail( type = :chat, line_count = 6 )
            #Log.method( self, __method__, type, line_count )
            matched_lines = []
            named_pattern = pattern( type )
            #puts 'Log.tail:  pattern == ' + named_pattern.inspect
            log_file_io = File.new( file )
            log_file_io.lines.reverse_each do |line|
                break if line_count <= matched_lines.length
                if line.match( / #{ named_pattern } /x )
                    #print '.'
                    matched_lines.unshift( line )
                end
            end
            matched_lines.join
        end
        private
        def self.patterns
            #2012-02-04 19:16:57 [INFO] warnost lost connection: disconnect.quitting
            #2012-02-04 19:16:57 [INFO] Connection reset
            #2012-02-04 20:01:56 [WARNING] warnost moved wrongly!
            #2012-02-04 20:17:36 [INFO] servel333 [/75.67.234.228:60579] logged in with entity id 1175707 at ([hyrule] -3004.3125, 6.0, -1236.71875)
            #2012-02-04 21:14:06 [INFO] <anaaispie> there are some aroudn my house though[0m
            #2012-02-04 21:14:06 [WARNING] Can't keep up! Did the system time change, or is the server overloaded?
            #2012-02-04 20:50:45 [INFO] Got position -3013.120795401102, 4.0, -1274.699999988079
            #2012-02-04 20:50:45 [INFO] Expected -3011.699999988079, 4.0, -1274.699999988079
            @@patterns ||= {
                'date'       => '([0-9][0-9][0-9][0-9])-([0-9]+)-([0-9]+)',    # YEAR-MONTH-DAY
                'time'       => '([0-9]+)[:]([0-9]+)[:]([0-9]+)',              # HOUR:MINUTE:SECOND
                'type'       => '\[([^\[\]]+)\]',                              # [TYPE]
                'chat_tail'  => '\<([^<>]+)\> (.*)',                           # <PLAYER> MESSAGE
                #'disconnect' => 'disconnect.quitting',
                'start'      => %w(  date  time  type  ),
                'chat'       => %w(  start  chat_tail  ),
                #'events'     => %w(),
            }
            @@patterns
        end
        def self.pattern( name )
            pattern = recurse_patterns( name )
            #puts 'Pattern == ' + pattern.inspect
            pattern
        end
        def self.recurse_patterns( current )
            current = current.to_s
            current = patterns[ current ]
            if current and current.kind_of? Array
                return current.map{ |p| recurse_patterns( p ) }.join('[ ]')
            else
                return current
            end
        end
        def self.files
            @@files = [] if ! defined? @@files or ! @@files
            @@files
        end
        def self.append_to_log( year, month, day, type )
            open_file = File.join( 'Logs', year, year + '-' + month + '-' + day + '.' + type + '.log' )
            files.push( open_file )
        end
        
    end
end
    
    # require 'yaml'
    # refs = open('FILE.yml') {|f| YAML.load(f) }
    # refs['PATH'].each do |ITEM|
    # end

class Bukkit < Minecraft
    
end

class ClassUnitTests
    def test_Minecraft
        
        Minecraft::ServerProperties.list
        
        puts Minecraft::ServerProperties.allow_nether;  
        puts Minecraft::ServerProperties.level_name;    
        puts Minecraft::ServerProperties.enable_query;  
        puts Minecraft::ServerProperties.allow_flight;  
        puts Minecraft::ServerProperties.server_port;   
        puts Minecraft::ServerProperties.enable_rcon;   
        puts Minecraft::ServerProperties.level_seed;    
        puts Minecraft::ServerProperties.server_ip;     
        puts Minecraft::ServerProperties.white_list;    
        puts Minecraft::ServerProperties.spawn_animals; 
        puts Minecraft::ServerProperties.online_mode;   
        puts Minecraft::ServerProperties.pvp;           
        puts Minecraft::ServerProperties.difficulty;    
        puts Minecraft::ServerProperties.server_name;   
        puts Minecraft::ServerProperties.gamemode;      
        puts Minecraft::ServerProperties.max_players;   
        puts Minecraft::ServerProperties.spawn_monsters;
        puts Minecraft::ServerProperties.view_distance; 
        puts Minecraft::ServerProperties.motd;          
        Minecraft.say_to_screen( 'This is a test of an automated message system.' )
    end
end
