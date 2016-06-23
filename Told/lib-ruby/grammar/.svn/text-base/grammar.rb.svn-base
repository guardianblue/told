require 'grammar/grammar_error.rb'
require 'grammar/grammar_symbol.rb'
require 'grammar/grammar_code.rb'
require 'grammar/semantic.rb' 

class Grammar
  
  attr_accessor :symbols, :comments
  attr_accessor :errors, :warnings
  attr_accessor :semantics
  attr_accessor :top_node
  attr_accessor :class_names
  
  def initialize(output_path = "")
    @empty = true
    @output_path = output_path
    @symbols = Hash.new
    @class_names = Hash.new
    @comments = Array.new
    @errors = Array.new
    @warnings = Array.new
    @semantics = Hash.new
    @listeners = Array.new
  end
  
  def add_listener(object)
    @listeners.push(object)
  end
  
  def remove_listener(object)
    @listeners.delete(object)
  end
  
  def source
    @source
  end
  
  def source=(value)
    @source = value
    @symbols.clear
    @class_names.clear
    @comments.clear
    @errors.clear
    @warnings.clear
    parse
  end
  
  def parse
    
    line_number = 1
    @source.each_line do |line|
      
      # create grammar symbol from each line
      symbol = GrammarSymbol.new(line, line_number)
      
      # process if it is a valid line
      if symbol.comment?
        # comment line
        @comments.push(line_number)
      elsif not symbol.empty?
        
        # check for inline groups
        if symbol.group? and symbol.expressions.length > 1
          symbol.expressions.each do |expr|
            if expr.type_name == :group
              symbol.add_error(GrammarError.new(expr, GrammarError.inline_group, symbol.symbol))
            end
          end
        end
        
        # Raise exception if the symbol with the same name has already been declared
        if symbol.errors
          @errors = @errors + symbol.errors
        elsif @symbols[symbol.symbol]
          @errors.push(GrammarError.new(symbol, GrammarError.duplicated_symbol(symbol.symbol)))
        else
          @symbols[symbol.symbol] = symbol
          @class_names[symbol.class_name] = symbol.symbol
        end
        
      end
      
      line_number += 1
      
    end
    
    # check if referenced symbols are all defined
    @symbols.each_value do |symbol|
      symbol.expressions.each do |expr|
        if expr.type_name == :group
          expr.choices.each do |choice|
            if choice.type_name == :lookup
              unless @symbols.has_key?(choice.symbol)
                @warnings.push(GrammarError.new(choice, GrammarError.undefined_symbol(choice.symbol), symbol.symbol))
              end
            end
          end
        elsif expr.type_name == :lookup
          unless @symbols.has_key?(expr.symbol)
            @warnings.push(GrammarError.new(expr, GrammarError.undefined_symbol(expr.symbol), symbol.symbol))
          end
        end
      end
    end
            
    # Create corresponding Semantic object for each symbol, but do not overwrite previously defined ones
    @symbols.each_key do |key|
      unless @semantics.has_key?(key)
        @semantics[key] = Semantic.new(key.to_s)
      end
    end
    
    @empty = false
    
    # Notify listeners for grammar changes
    fire_grammar_changed
    
  end
  
  # check for any symbol that is referenced but never defined
  def check_undefined_symbol
    
  end
  
  # return an array of the literal defined in the grammar, to make up the tokenizer
  def literals
    patterns = []
    @symbols.each_value do |symbol|
      symbol.expressions.each do |expr|
        if [:literal, :regexp].include?(expr.type_name)
          patterns.push(expr.token_pattern)
        elsif expr.type_name == :group
          patterns = patterns + expr.literals
        end
      end
    end
    patterns.uniq
  end
  
  def codes
    @symbols.each_pair do |key, value|
      code = GrammarCode.new(value, @semantics[key])
      yield(key, code.to_s)
    end
  end
  
  def symbol_code(symbol)
    GrammarCode.new(symbols[symbol], @semantics[symbol]).to_s
  end
  
  def fire_grammar_changed
    @listeners.each do |listener|
      listener.grammar_changed(self)
    end
  end
  
  def errors?
    @errors.length > 0
  end
  
  def issues?
    @errors.length + @warnings.length > 0
  end
  
  def empty?
    @empty
  end
  
  def ready?
    !errors? and !empty?
  end
  
  def sorted_errors
    all_errors = @errors + @warnings
    all_errors.sort! {|a,b|
      if a.content.line_number == b.content.line_number
        a.content.column_start <=> b.content.column_start
      else
        a.content.line_number <=> b.content.line_number
      end
    }
    all_errors
  end
  
  def class_name_to_symbol(target)
    @class_names[target]
  end
  
  def size
    value = 0
    value += @source.length
    @semantics.values do |semantic|
      value += semantic.size
    end
    value
  end
  
  protected
  def generate_runtime
    
  end
  
end