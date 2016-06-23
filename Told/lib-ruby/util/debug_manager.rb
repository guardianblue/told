class DebugManager
  
  @@messages = {
                  :tokenizer => false, 
                  :parser => false, 
                  :runtime => false,
                  :symbol => false,
                  :error => true,
                  :user => true
               }
  
  def self.messages
    @@messages
  end
  
  def self.show_message?(level)
    if @@messages.has_key?(level)
      @@messages[level]
    else
      false
    end
  end
  
  Object.module_eval{
    def debug(message)
      level_debug(:user, message)
    end
    
    def level_debug(level, message)
      level = :user unless DebugManager.messages.has_key?(level)
      if DebugManager.show_message?(level)
        message.to_s.each_line do |line|
          (level == :error ? $stderr : $stdout).puts "[#{level.to_s.upcase}] #{line.chomp}"
        end
      end
    end
    
  }
  
end