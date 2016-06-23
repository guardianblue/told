#The TokenError class provides exception information for Tokenizer
class TokenError < RuntimeError
  
  attr_accessor :line, :column, :message
  
  def initialize(line = 0, column = 0, message = TokenError.unexpected) 
    super()
    @line = line
    @column = column
    @message = message
  end

  def self.unexpected
    "Unexpected token"
  end
    
  def to_s
    "Tokenizer Error at #{line}, column #{column + 1}\n>> #{message}"
  end
  
end

class InfiniteTokenError < RuntimeError
  
  def to_s
    "Some rules in grammar definition has caused infinite loop in Tokenizer\nPossible reason might be some rules matches with zero-length result"
  end
  
end
