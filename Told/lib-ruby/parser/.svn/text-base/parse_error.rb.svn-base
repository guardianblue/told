# The ParseError class provides error information at the parse stage.
class ParseError < RuntimeError
  
  attr_reader :token, :description
  
  # Error message when the +expecting+ token is not found
  def self.mismatched(expecting, found)
    "#{expecting.to_s} expected, token <#{found}> found instead"
  end
  
  # Error message when +expecting+ is not a valid subclass of LanguageUnit.
  def self.unknown_type(expecting)
    "#{expecting.to_s} is an unknown type"
  end
  
  # Error message when the parsing is ended with remaining tokens left
  def self.remaining_token
    "Should have reached the end of Program, but there are tokens left"
  end
  
  # Error message when the parsing is not ended, but there are not more tokens left
  def self.no_more_tokens(expecting)
    "[#{expecting.value_label}] expected, but there are no more tokens"
  end
  
  # Initialize a ParseError object
  def initialize(token, description)
    @token = token
    @description = description
  end
  
  # Location for this error
  def location
    "Line " + @token.line_number.to_s
  end
  
  # The detailed information of this error
  def to_s
    if @token
      "Parse Error at #{location}\n>> #{description}"
    else
      "Parse Error:\n>> #{description}"
    end
  end
  
end