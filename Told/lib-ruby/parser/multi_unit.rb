require 'parser/language_unit.rb'

# The MultiUnit class implements a language unit that can be one of the 
# language units defined in its +possible_units+ class method.
# Any Grammar symbol that is in the following form:
# * grammar_symbol = choice_a | choice_b | choice_c
# will be handled by this class
#
# Basically, you need not use the methods provided by this class.
# For most of the cases, calling +evaluate_first+ and +typecheck_first+ will suffice

class MultiUnit < LanguageUnit
  
  # Determine whether this class is sub-class of MultiUnit
  def self.multi_class
    true
  end
  
  # Determine whether this object is an instance of MultiUnit
  def multi_instance
    true
  end
  
  # The array of parsable language units
  def self.possible_units
    []
  end
  
  # Test if a token agrees with this MultiUnit. 
  #
  # Return true if any of the +possible_units+ matches the token
  def self.test(token)
    self.possible_units.each do |unit|
      level_debug(:parser, "#{self.to_s} match <#{unit}> with #{token}")
      if match_token(unit, token)
        level_debug(:parser, "<#{unit}> matched")
        return true
      end
    end
    level_debug(:parser, "#{self.to_s}: no match found")
    false
  end
  
  # Parsing. Test against all possible unit, and parse with the first successful match
  def parse(tokenizer)
    parsed_unit = nil
    self.class.possible_units.each do |unit|
      if self.class.match_token(unit, tokenizer.peek_next)
        if unit.kind_of? Regexp
          # for literal tokens, do not parse it
          parsed_unit = tokenizer.next
          self.expressions.push(parsed_unit)
          break
        else
          # for language unit, parse it recursively
          parsed_unit = unit.new
          parsed_unit.parent = self
          parsed_unit.token = tokenizer.peek_next
          self.expressions.push(parsed_unit)
          parsed_unit.parse(tokenizer)
          break
        end
      end
    end
    
    if parsed_unit
      parsed_unit
    else
      raise ParseError, ParseError.expecting(self)
    end
  end
  
  protected
  def self.match_token(unit, token)
    if unit.kind_of? Regexp
      return unit =~ token.content
    elsif unit.kind_of?(Class)
      if unit.new.kind_of? self
        # recursive definition
        false
      elsif unit.new.kind_of?(LanguageUnit)
        return unit.test(token)
      end
    end
    false
  end  
  
end