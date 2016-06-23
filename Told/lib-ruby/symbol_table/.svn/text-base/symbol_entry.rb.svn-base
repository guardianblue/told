# The SymbolEntry class is used by SymbolTable to hold the information of a variable entry

class SymbolEntry
  attr_accessor :type, :value
  attr_reader :name

  # Instanstiate a symbol entry
  def initialize(name, type, value=nil)
    @name = name
    @type = type
    @value = value
  end

  # Prints the information of the symbol entry
  def to_s
    "#{name} <#{type}>: #{value}"
  end
  
end
