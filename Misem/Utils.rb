
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
