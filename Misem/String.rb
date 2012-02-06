
class String
    
    def indent( indentWith = '    ' )
        self.lines.map{ |item| indentWith + item }.join
    end
    
end
