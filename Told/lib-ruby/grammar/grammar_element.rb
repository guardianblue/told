# Base class for all grammar elements
class GrammarElement
  
  attr_accessor :modifier     # repetition modifier for this element
  attr_reader   :code
  attr_accessor :line_number
  attr_accessor :column_start
  attr_accessor :column_end
  
  def initialize(line_number = 0)
    @modifier = :once         # default modifier
    @line_number = line_number
    @errors = []
  end
  
  # whether this grammar element use single pattern checking or not
  # override if expectation array should be used instead
  # TODO: single pattern look-ahead should not be used when implementing non-prefix grammar
  def use_pattern?
    true
  end
    
  def pattern
    ""
  end
  
  def class_name
    ""
  end
  
  def file_name
    ""
  end
  
  def referenced_name
    ""
  end
  
  def type_name
    :element
  end
  
  def errors
    @errors.length > 0 ? @errors : false
  end
  
  def add_error(value)
    @errors.push(value)
  end
  
  protected
  
  # borrowed from rails API
  def camelize(s)
    s.to_s.gsub(/\/(.?)/) { "::" + $1.upcase }.gsub(/(^|_)(.)/) { $2.upcase }
  end
  
end