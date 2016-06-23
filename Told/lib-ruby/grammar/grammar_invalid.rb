require 'grammar/grammar_element.rb'
class GrammarInvalid < GrammarElement
  
  attr_reader :symbol
  
  def initialize(line_number, symbol)
    super(line_number)
    @symbol = symbol
  end
  
  def type_name
    :invalid
  end
end