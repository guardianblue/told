require 'grammar/grammar_element.rb'

class GrammarLiteral < GrammarElement
  
  attr_reader :literal
  
  def initialize(literal, line_number = 0)
    super(line_number )
    @literal = literal
    @expressions = [].push(@literal)
  end
  
  def raw_pattern
    Regexp.escape(@expressions.first[1..-2]).gsub("/", "\\/")
  end
  
  def token_pattern
    if self.raw_pattern =~ /^\w+$/
      "/#{raw_pattern}\\b/"
    else
      "/#{raw_pattern}/"
    end
  end
  
  def pattern
    "/^#{raw_pattern}$/"
  end
  
  # TODO: problematic when encountering grammars like: symbol = other_symbol | <literal>
  # Should have been fixed, but tests are needed
  def referenced_name
    pattern
  end
  
  def type_name
    :literal
  end
  
  def to_s
    "Literal(#{@expressions.first})" + (@modifier == :once ? "" : @modifier.to_s)
  end
  
end