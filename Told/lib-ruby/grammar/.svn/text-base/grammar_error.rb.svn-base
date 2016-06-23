class GrammarError < RuntimeError
  
  attr_accessor :content, :description, :symbol
  
  def self.unopened_separation
    "Seperation Sign (|) found without preceeding element"    
  end
  
  def self.unclosed_separation
    "Seperation Sign (|) found without succeeding element"    
  end
  
  def self.invalid_kleene
    "Kleene Expansion Sign (*) found without preceeding element"    
  end
  
  def self.invalid_optional
    "Optional Sign (?) found without preceding element"    
  end
  
  def self.undefined_symbol(symbol)
    "Symbol #{symbol} is referenced but not defined"
  end
  
  def self.duplicated_symbol(symbol)
    "Duplicated symbol: #{symbol}"
  end
  
  def self.invalid_grammar
    "Grammar should be in <symbol> = <production> format"
  end
  
  def self.inline_group
    "Inline multiple-choice group is not allowed"
  end
  
  def initialize(content, description, symbol = nil)
    @content = content
    @description = description
    @symbol = symbol.nil? ? @content.symbol : symbol 
  end
  
  def location
    "Line " + @content.line_number.to_s
  end
    
end