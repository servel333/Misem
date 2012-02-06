
class ClassUnitTests
    def run
        self.methods.each do |m|
            if m.match( /^ test_ /x )
                puts 
                puts
                puts '########################################'
                puts '##  Running "' + m + '" (' + m.inspect + ')'
                send( m )
            end
        end
    end
    def self.run
        self.new().run
    end
end
