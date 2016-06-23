# An Expectation object defines an element in the 'expecting' array of a language unit
class Expectation
  attr_reader :value, :modifier
  
  # Defines a new Expectation. 
  #
  # [value] The language unit to expect. Can be a String or any subclass of LanguageUnit
  #
  # [modifier] The modifier of this Expectation. Options are:
  # <tt>:once</tt>:: The parser would expect this Expectation to run exactly one time. (Default)
  # <tt>:optional</tt>:: The parser would continue to next expecting LanguageUnit if this rule is not matched.
  # <tt>:kleene</tt>:: The parser would repeat this Expectation as many times as possible (kleene expansion). After that, continue with next Expectation.
  def initialize(value, modifier = :once)
    if value.kind_of? String
      @value = Regexp.new('^' + Regexp.escape(value) + '$')
    else
      @value =  value
    end
    @modifier = modifier
    @consumed = false
  end
  
  # Consume this expectation. The parser will continue on next expectation.
  def consume
    @consumed = true
  end
  
  # Reset this expectation to its initial state
  def reset
    @consumed = false
  end
  
  # Returns whether this expectation is consumed or not
  def consumed?
    @consumed
  end
  
  def to_s
    label
  end
  
  def label
    "#{value_label}#{modifier_label}"
  end
  
  def value_label
    if value.kind_of?(Regexp)
      "/#{value.source}/"
    else
      value.to_s
    end
  end
  
  def modifier_label
    if modifier != :once
      " #{modifier.to_s}"
    else
      ""
    end
  end
  
end