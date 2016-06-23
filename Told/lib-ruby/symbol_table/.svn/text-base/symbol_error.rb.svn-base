# The SymbolError class provides exception information for SymbolTable
class SymbolError < RuntimeError

  # A symbol being called, but the symbol table cannot locate it
  def self.must_declare(name)
    "Symbol is not declared: #{name}"
  end

  # The same symbol is being declared multiple times
  def self.multiple_declare(name)
    "Symbol has already been declared: #{name}"
  end
  
  # The symbol does not have a value, but is being requested for a value
  def self.not_initialized(name)
    "Symbol has not been initialized: #{name}"
  end

end
