
class Console
    
    # Writes the message to the named screen
    # newline characters are not appended to the message.
    def self.write_to_screen( screen_name, message )
        %x(screen -x #{screen_name} -X stuff "`printf "#{message}"`")
    end
    
    def self.attach_to_screen( screen_name )
        %x(screen -r #{screen_name})
    end
    
    def self.wipe_screens()
        %x(screen -wipe)
    end
    
end
