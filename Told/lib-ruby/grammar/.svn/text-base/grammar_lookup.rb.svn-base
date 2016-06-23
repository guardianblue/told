# Holds the information for a grammar symbol lookup

class GrammarLookup < GrammarElement
  
  attr_reader :symbol
  
  def initialize(symbol, line_number = 0)
    super(line_number)
    @symbol = symbol
  end
  
  # return the string to use as the class name for this grammar rule
  def class_name
    camelize(symbol)
  end
  
  def referenced_name
    class_name
  end
  
  def pattern
    class_name + ".pattern"  
  end
  
  # return the file name for the class file 
  def file_name
    symbol + ".rb"
  end
  
  def type_name
    :lookup
  end
  
  def to_s
    "LanguageUnit(" + symbol + ")" + (@modifier == :once ? "" : @modifier.to_s)
  end
  
end