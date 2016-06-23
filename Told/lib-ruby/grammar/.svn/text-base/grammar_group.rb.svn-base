require 'grammar/grammar_element.rb'

class GrammarGroup < GrammarElement
  
  attr_reader :choices
  
  def initialize(line_number = 0)
    super(line_number)
    @choices = []
  end
  
  def add(element)
    @choices.push(element)
  end
  
  def literals
    result = []
    @choices.each do |choice|
      if [:regexp, :literal].include?(choice.type_name)
        result.push(choice.pattern)
      end
    end
    result
  end
  
  def type_name
    :group
  end
  
  def to_s
    "MultiUnit(" + @choices.collect{|choice| choice.to_s}.join(", ") + ")" + (@modifier == :once ? "" : @modifier.to_s)
  end
  
end