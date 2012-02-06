
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
        def [](key);    prop(key);  end
        def method_missing(sym, *args);     self[sym];      end
        
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
        
        def self.tail( line_count = 6, *types )
            Out.method( self, __method__, line_count, *types )
            puts self.to_s + '.' + __method__.to_s + '{  patterns == ' + patterns( *types ).inspect + '  }'
            matched_lines = []
            
            #log_file_io = File.new( file )
            #log_file_io.lines.reverse_each do |line|
            #    break if line_count <= matched_lines.length
            #    patterns( *types ).each do |pattern|
            #        matched_lines.unshift( line )  if line.match( / #{ pattern } /x )
            #    end
            #end
            matched_lines.join
        end
        
        private
        
        def self.patterns( *names )
            names.map do |name|
                named_patterns[ name ]
            end
        end
        
        def self.pattern_parts
            if ! defined? @@pattern_parts
                
                @@pattern_parts = {}
                @@pattern_parts['']     = ''
                @@pattern_parts['n']    = '([0-9]+)'       # 0
                @@pattern_parts['-n.']  = '(-?[0-9.]+)'    # -0.0
                @@pattern_parts['w']    = '([\w]+)'         # word
                @@pattern_parts['ws+']  = '([\w\s]+)'       # words and spaces
                @@pattern_parts['^s']   = '([^\s]+)'        # not whitespace
                @@pattern_parts['[w]']  = '\[([^\[\]]+)\]'  # [word]
                @@pattern_parts['<w>']  = '<([^<>]+)>'      # <word>
                @@pattern_parts['...']  = '(.*)'            # <word>
                @@pattern_parts['year'] = '([0-9][0-9][0-9][0-9])' # 0000
                
                @@pattern_parts['year:n:n']     = assemble( %w( year : n : n        ), '' )
                @@pattern_parts['n-n-n']        = assemble( %w(    n - n - n        ), '' )
                @@pattern_parts['ip']           = assemble( %w(    n . n . n . n    ), '' )
                @@pattern_parts['ip:port']      = assemble( %w(  n . n . n . n : n  ), '' )
                
                # @@pattern_parts['type']              = '\[([^\[\]]+)\]',                            # [TYPE]
                # @@pattern_parts['info_type']         = '\[INFO\]',                                  # [INFO]
                # @@pattern_parts['warning_type']      = '\[WARNING\]',                               # [WARNING]
                # @@pattern_parts['chat_tail']         = '\<([^<>]+)\> (.*)',                         # <PLAYER> MESSAGE
                # @@pattern_parts['disconnects_tail']  = '([^\s])[ ]lost[ ]connection:[ ]disconnect.quitting'
                # @@pattern_parts['connect_player']    = '([^\s]+)'
                # @@pattern_parts['connect_ip']        = '\[\/*[0-9]+[.][0-9]+[.][0-9]+[.][0-9]+[:][0-9]+\]'
                # @@pattern_parts['connect_mid']       = 'logged[ ]in[ ]with[ ]entity[ ]id[ ][0-9]+[ ]at'
                # @@pattern_parts['connect_tail']      = '\(\[([^()])\][ ](-?[0-9+]),[ ](-?[0-9+]),[ ](-?[0-9+])\)'
                # @@pattern_parts['general_tail']      = '(.*)'
                
            end
            @@pattern_parts
        end
        
        def self.named_patterns
            
            #2012-02-04 19:16:57 [INFO] warnost lost connection: disconnect.quitting
            #2012-02-04 19:16:57 [INFO] Connection reset
            #2012-02-04 20:01:56 [WARNING] warnost moved wrongly!
            #2012-02-04 20:17:36 [INFO] servel333 [/75.67.234.228:60579] logged in with entity id 1175707 at ([hyrule] -3004.3125, 6.0, -1236.71875)
            #2012-02-04 21:14:06 [INFO] <anaaispie> there are some aroudn my house though[0m
            #2012-02-04 21:14:06 [WARNING] Can't keep up! Did the system time change, or is the server overloaded?
            #2012-02-04 20:50:45 [INFO] Got position -3013.120795401102, 4.0, -1274.699999988079
            #2012-02-04 20:50:45 [INFO] Expected -3011.699999988079, 4.0, -1274.699999988079
            
            @@named_patterns ||= {
                # YEAR-MM-DD HH-MM-SS [TYPE] PLAYER lost connection: disconnect.quitting
                'disconnects'   => assemble( %w(  year:n:n  n-n-n  [w]       w  ws+  disconnect.quitting  ) ),
                # YEAR-MM-DD HH-MM-SS [TYPE] PLAYER [/IP:PORT] logged in with entity id NNN at ([WORLD] X, Y, Z)
                'connects'      => assemble( %w(  year:n:n  n-n-n  [w]       w  \[\/?  ip:port  \]  \[\/?  id  n  at  \(  [w]  -n.  ,  -n.  ,  -n.  \)  ) ),
                # YEAR-MM-DD HH-MM-SS [TYPE] <PLAYER> MESSAGE
                'chat'          => assemble( %w(  year:n:n  n-n-n  [w]       <w>  ^s  ) ),
                # YEAR-MM-DD HH-MM-SS [INFO] MESSAGE
                'info'          => assemble( %w(  year:n:n  n-n-n  [INFO]    ...  ) ),
                # YEAR-MM-DD HH-MM-SS [WARNING] MESSAGE
                'warning'       => assemble( %w(  year:n:n  n-n-n  [WARNING] ...  ) ),
            }
            @@named_patterns
        end
        
        def self.assemble( parts, sep = '[ ]' )
            parts = parts.map do |p|
                pattern_parts[p]  if pattern_parts.has_key?(p)
                p
            end
            parts.join( sep )
        end
        
        def self.recurse_patterns( name )
            name = name.to_s.downcase
            pattern = @@pattern_parts[ name ]
            if pattern and pattern.kind_of? Array
                return pattern.map{ |p| recurse_patterns( p ) }.join('[ ]*')
            else
                return pattern
            end
        end
        
        #def self.files
        #    @@files = [] if ! defined? @@files or ! @@files
        #    @@files
        #end
        #
        #def self.append_to_log( year, month, day, type )
        #    open_file = File.join( 'Logs', year, year + '-' + month + '-' + day + '.' + type + '.log' )
        #    files.push( open_file )
        #end
        
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
