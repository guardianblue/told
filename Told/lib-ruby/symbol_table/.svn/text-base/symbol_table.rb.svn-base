require 'symbol_table/symbol_entry.rb'
require 'symbol_table/symbol_error.rb'

# The SymbolTable class encapsulates the operations used by the compile/interpreter regarding variable handling.
# In fact, a SymbolTable object only deals with symbols on a particular scope level. Therefore, it can be used or extend to provide the complete symbol table functionality based on different language designs (such as scoping policy)
#
# You can change the type of SymbolTable to use in the Settings Panel
class SymbolTable

  attr_accessor :table
  attr_reader :scope

  DEFAULT_SCOPE = "global"
  DEFAULT_TYPE = "string"
 
  # Instansiate a symbol table object with a specified scope. If the scope is not specified, the global scope will be used.
  def initialize(scope = DEFAULT_SCOPE)
    @table = Hash.new
    @scope = scope
    @listeners = []
  end
  
  def addListener(l)
    @listeners.push(l)
  end
  
  # Add(Declare) a symbol entry in the symbol table
  # If there exist a symbol with the same name, a SymbolError will be raised
  # You are advised to prevent the exception by check for any conflict before hand
  def add_entry(name, type, value = nil)
    add(SymbolEntry.new(name, type, value))
  end

  # Same as SymbolTable#add_entry, but takes a SymbolEntry as input 
  def add(entry)
    level_debug(:symbol, "Added Entry: #{entry.name} in scope #{@scope}")
    if table.has_key? entry.name
      raise SymbolError, SymbolError.multiple_declare(entry.name)
    end
    table[entry.name] = entry
    fire_updated
  end

  # Check whether a symbol in defined in any scope and return its value, return nil otherwise
  # If there are more than one entry with the same name
  # The most appropiate one will be returned based on the type of this symbol table.
  def contains?(name)
    table[name]
  end

  # Similiar to SymbolTable#contains?, finds an entry with the specified name
  # The difference is that a SymbolError will be raised if the entry is not found
  def find(name)
    unless table.has_key?(name)
      raise SymbolError, SymbolError.must_declare(name)
    end
    table[name]
  end
  
  # Return the type of a symbol.
  # If the symbol is not defined, SymbolError will be raised.
  def lookup_type(name)
    unless table.has_key?(name)
      raise SymbolError, SymbolError.must_declare(name)
    end
    table[name].type
  end
  
  # Return the value of a symbol.
  # If the symbol is not defined, or does not have a value yet, SymbolError will be raised
  def lookup_value(name)
    entry = find(name)
    unless entry.value
      raise SymbolError, SymbolError.not_initialized(name)
    end
    entry.value
  end

  # Change the value of a symbol.
  # If the symbol is not defined, SymbolError will be raised.
  def update(name, value)
    entry = find name
    entry.value = value
    level_debug(:symbol, "Updating symbol: #{name} with value [#{value}]")
    fire_updated
  end 
  
  # Enter a different scope. 
  # You can use the corresponding LanugaugeUnit as the unique identifier of this scope.
  def enter_scope(unit)
    level_debug(:symbol, "Enter scope of: #{unique_identifier(unit)}")
    fire_updated
  end
  
  # Exit the current scope.
  # The symbol table will recover to previous scope based on the type of this symbol table
  def exit_scope
    fire_updated
  end
  
  alias has_symbol? contains?
  alias set update
  
  protected
  def fire_updated
    @listeners.each do |l|
      l.symbol_table_updated
    end
  end
  
  def unique_identifier(unit)
    "<#{unit.to_s}#:#{unit.id}>"
  end

end

# Data structure for LexicalSymbolTable
class LexicalTree
  
  attr_accessor :parent, :table
  
end

# Class definition for LexicalSymbolTable. For usage of methods, please refer to SymbolTable.
class LexicalSymbolTable < SymbolTable
  
  def initialize(scope = DEFAULT_SCOPE)
    super(scope)
    @tables = Hash.new
    @global_scope = LexicalTree.new
    @global_scope.parent = @global_scope
    @global_scope.table = SymbolTable.new
    @current_scope = @global_scope
    @tables["global"] = @global_scope
  end
  
  def enter_scope(unit)
    super
    #@last_scope = @current_scope
    if @tables.has_key? unique_identifier(unit)
      @current_scope = @tables[unique_identifier(unit)]
    else
      new_scope = LexicalTree.new
      new_scope.parent = @current_scope
      new_scope.table = SymbolTable.new(unique_identifier(unit))
      @tables[unique_identifier(unit)] = new_scope
      @current_scope = new_scope
    end
  end
  
  def exit_scope
    super
    #@current_scope = @last_scope
    @current_scope = @current_scope.parent
  end
  
  def current_symbol_table
    @current_scope.table
  end
  
  def locate_symbol_table(name)
    
    result = nil
    scope = @current_scope
    begin
      if scope.table.has_symbol?(name)
        result = scope.table
        break
      end
      
      # already reached global scope
      if scope == @global_scope
        break
      end        
      scope = scope.parent
    end while scope 
    
    result
  end
  
  def locate_symbol_table!(name)
    result = locate_symbol_table(name)
    unless result
      raise SymbolError, SymbolError.must_declare(name)
    end
    result
  end
  def contains?(name)
    (locate_symbol_table(name) != nil)
  end
  
  def find(name)
    table = locate_symbol_table!(name)
    table.find(name)
  end
  
  def lookup_type(name)
    table = locate_symbol_table!(name)
    table.lookup_type(name)
  end
  
  def lookup_value(name)
    table = locate_symbol_table!(name)
    table.lookup_value(name)
  end
  
  def update(name, value)    
    table = locate_symbol_table!(name)
    table.update(name, value)
    fire_updated
  end
  
  def add(entry)
    table = current_symbol_table
    table.add(entry)
    fire_updated
  end
  
  def symbol_list
    @result = Array.new
    @tables.each_pair do |k, v|
      v.table.table.each_pair do |k1, entry|
        @result.push [k, entry]
      end
    end
    @result
  end
  
end

# Class definition for DynamicSymbolTable. For usage of methods, please refer to SymbolTable.
class DynamicSymbolTable < SymbolTable
  
  def initialize(scope = DEFAULT_SCOPE)
    super(scope)
    @stack = Array.new
    @stack.push(SymbolTable.new)
  end
  
  def enter_scope(unit)
    super
    @stack.push(SymbolTable.new(unique_identifier(unit)))
  end
  
  def exit_scope
    super
    @stack.pop
  end
  
  def current_symbol_table
    @stack.last
  end
    
  def locate_symbol_table(name)
    result = nil
    @stack.reverse.each do |table|
      if table.has_symbol? name
        result = table
        break
      end
    end
    
    result
  end
  
  def locate_symbol_table!(name)
    result = locate_symbol_table(name)
    unless result
      raise SymbolError, SymbolError.must_declare(name)
    end
    result
  end
  
  def contains?(name)
    (locate_symbol_table(name) != nil)
  end
  
  def find(name)
    table = locate_symbol_table!(name)
    table.find(name)
  end
  
  def lookup_type(name)
    table = locate_symbol_table!(name)
    table.lookup_type(name)
  end
  
  def lookup_value(name)
    table = locate_symbol_table!(name)
    table.lookup_value(name)
  end
  
  def update(name, value)
    table = locate_symbol_table!(name)
    table.update(name, value)
    fire_updated
  end
  
  def add(entry)
    table = current_symbol_table
    table.add(entry)
    fire_updated
  end
  
  def symbol_list
    @result = Array.new
    @stack.each do |t|
      t.table.each_pair do |k, entry|
        @result.push [t.scope, entry]
      end
    end
    @result
  end
    
end
