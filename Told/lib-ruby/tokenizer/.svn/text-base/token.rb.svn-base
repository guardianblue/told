class Token
  
  attr_accessor :content, :rule
  attr_accessor :line_number, :column_start
  
  def initialize(content, line_number, column_start)
    @content = content
    @line_number = line_number
    @column_start = column_start
  end
  
  alias :line_start :line_number
  alias :line_end :line_number
  
  def token_instance
    true
  end
  
  # Returns the end of the token in the source code
  def column_end
    @column_start + @content.length - 1
  end
  
  def evaluate
    # Stub to prevent exception in parsing
    content
  end
  
  def location
    "Line #{@line_number}, Column #{@column_start + 1}"
  end
  
  # Returns the type information of this token
  def type_label
    "Token"
  end
  
  def to_s
    "#{@content}"
  end
  
end