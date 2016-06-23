require 'grammar/grammar_element.rb'

class GrammarRegexp < GrammarElement
  
  attr_reader :regexp, :regexp_source
  
  def initialize(regexp, line_number = 0)
    super(line_number)
    
    @regexp_source = regexp
    @regexp = Regexp.new(eval(regexp))
    @expressions = [].push(@regexp_source)
  end
  
  def pattern
    @regexp_source
  end
  
  def token_pattern
    pattern
  end
    
  def referenced_name
    class_name
  end
  
  def type_name
    :regexp
  end
  
  def to_s
    "Regular Expression(#{@expressions.first})" + (@modifier == :once ? "" : @modifier.to_s)
  end
  
end