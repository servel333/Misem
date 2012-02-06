
# Output control
class Out
    def self.method_to_s( class_ref, method_symbol, *params )
        desc = ''
        desc += class_ref.name + '.'    if class_ref
        desc += method_symbol.to_s      if method_symbol
        if params and 0 < params.length
            desc += '(  ' + params.map{ |p| p.inspect }.join('  ') + '  )'
        else
            desc += '()'
        end
        desc
    end
    def self.method( class_ref, method_symbol, *params )
        puts method_to_s( class_ref, method_symbol, *params )
    end
end

=begin

class Out < File
    
    def initialize( name, io, also_write_to = [] )
        @@io = make_file_io( name )
        
        class.Logs.push( self )
    end
    
    def time_first_called;      @@time_first_called ||= Time.now; @@time_first_called;  end
    def log_timestamp;          time_first_called.strftime("%Y-%m-%dT%H-%M-%S");        end
    
    def make_file_io( name )
        file = File.join( path, log_timestamp + '-' + name + '.log.txt' )
        FileUtils.mkdir_p( File.dirname( file ) )
        file_io = File.new( file, 'w' )
    end
    
    def define_io_methods(  )
        
        ios.push( io )
        
    end

=end
