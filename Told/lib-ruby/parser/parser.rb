# The Parse class acts as a namespace for the user-defined grammar.
# Avoids name conflicts with any Built-in Ruby Class names

require 'parser/language_unit.rb'
require 'parser/multi_unit.rb'

class Parser
  def initialize
    super
  end
  
  def self.to_s
    "Parser"
  end
  
  def to_s
    "Parser object"
  end
end