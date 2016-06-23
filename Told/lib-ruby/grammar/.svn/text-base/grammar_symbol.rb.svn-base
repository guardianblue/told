require 'grammar/grammar_element.rb'
require 'grammar/grammar_error.rb'
require 'grammar/grammar_group.rb'
require 'grammar/grammar_literal.rb'
require 'grammar/grammar_lookup.rb'
require 'grammar/grammar_regexp.rb'
require 'grammar/grammar_invalid.rb'

class GrammarSymbol < GrammarElement
  
  attr_reader :symbol       # the symbol (i.e. LHS) of this grammar rule
  attr_reader :production   # the production (i.e. RHS) of this grammar rule
  attr_reader :expressions  # parsed symbols in array form
  attr_reader :source       # the raw form of the grammar rule
  
  PATTERN_RULE = /^([a-zA-Z][a-zA-Z_0-9]*)[\s]*=[\s]*(.+)$/
  PATTERN_SEPARATION = /^\|$/
  PATTERN_KLEENE = /^\*$/
  PATTERN_OPTIONAL = /^\?$/
  PATTERN_LITERAL = /^"(?:[^"\\]*(?:\\.[^"\\]*)*)"$/
  PATTERN_SYMBOL = /^[a-zA-Z][a-zA-Z_0-9]*$/
  PATTERN_REGEXP = /^\/.*\/$/
  PATTERN_COMMENT = /^\s*#.*$/
  
  def empty?
    @empty
  end
  
  def group?
    @group
  end
  
  def comment?
    @comment
  end
  
  # Transform grammar symbol definition into logical objects
  def initialize(source, line_number)
    super(line_number)
    @source = source
    @expressions = []
    @empty = true
    @group = false
    
    if PATTERN_COMMENT.match(source)
      @comment = true
      return
    end
    @comment = false
    
    # Match the definition string against the pattern
    match = PATTERN_RULE.match(source)
    if match and match[2] != " "
      @empty = false
      @symbol = match[1]
      @production = match[2] + " "
      
      # mark the position of the symbol, for syntax highlighting
      @column_start = match.begin(1)
      @column_end = match.end(1) - 1
      production_column = match.begin(2)      
      column_number = 0
      
      rules = Array.new
      rules_begin = Array.new
      
      # literals with spaces inside is not allowed yet
      #rule_rxp = /"(?:[^"\\]*(?:\\.[^"\\]*)*)"\s+|^\S*\s+/
      
      rule_rxp = /^\S+\s+/
      combinded_rxp = /^[a-zA-Z][a-zA-Z_0-9]*[\?\*]$/
      
      while column_number < @production.length do
        match_rule = rule_rxp.match(@production[column_number..-1])
        if match_rule
          # found
          match_stripped = match_rule[0].strip
          if combinded_rxp.match(match_stripped)
            # check rules that composed of symbol_lookup and modifier (?,*)
            rules.push(match_stripped[0..-2])
            rules_begin.push(production_column + column_number)
            rules.push(match_stripped[-1..-1])
            rules_begin.push(production_column + column_number + match_stripped.length - 1)
          else
            rules.push(match_stripped)
            rules_begin.push(production_column + column_number)
          end
          column_number += match_rule.end(0)
        else
          # should not be here
        end
      end
      
      rules.push(";") # terminating symbol
      
      last_symbol = nil
      add_to_group = false
      
      i = 0
      rules.each do |r|
        
        #puts r
        if PATTERN_SEPARATION.match(r)
          #puts "MATCHED SEPARATION"
          #--- handle separation symbol
          
          # throw exception if last_symbol is nil
          unless last_symbol
            err = GrammarInvalid.new(@line_number, @symbol)
            err.column_start = rules_begin[i]
            err.column_end = rules_begin[i]
            @errors.push(GrammarError.new(err, GrammarError.unopened_separation))
          end
          
          if last_symbol.kind_of? GrammarGroup
            # symbol group already built, do nothing
          else
            @group = true
            # build a new symbol group
            group = GrammarGroup.new(@line_number)
            group.column_start = rules_begin[i - 1]
            group.add(last_symbol)
            last_symbol = group
          end
          add_to_group = true
          
        elsif PATTERN_KLEENE.match(r)
          #puts "MATCHED KLEENE"
          #--- handle kleene expansion symbol
          
          unless last_symbol
            err = GrammarInvalid.new(@line_number, @symbol)
            err.column_start = rules_begin[i]
            err.column_end = rules_begin[i]
            @errors.push(GrammarError.new(err, GrammarError.invalid_kleene))
          end
          last_symbol.modifier = :kleene
          @expressions.push(last_symbol) if last_symbol
          last_symbol = nil
          
        elsif PATTERN_OPTIONAL.match(r)
          #puts "MATCHED OPTIONAL"
          #--- handle optional symbol
          
          unless last_symbol
            err = GrammarInvalid.new(@line_number, @symbol)
            err.column_start = rules_begin[i]
            err.column_end = rules_begin[i]
            @errors.push(GrammarError.new(err, GrammarError.invalid_optional))
          end
          last_symbol.modifier = :optional
          @expressions.push(last_symbol) if last_symbol
          last_symbol = nil
          
        else
          #---  handle actual elements
 
          if PATTERN_LITERAL.match(r)
            #puts "MATCHED LITERAL"
            this_symbol = GrammarLiteral.new(r, @line_number)
          elsif PATTERN_REGEXP.match(r)
            #puts "MATCHED REGEXP"
            this_symbol = GrammarRegexp.new(r, @line_number)
          elsif PATTERN_SYMBOL.match(r)
            #puts "MATCHED SYMBOL"
            # the name of the symbol is stored into a GrammarLookup object for later reference
            this_symbol = GrammarLookup.new(r, @line_number)
          else
            if r == rules.last
              if add_to_group
                # Error: unfinished group
                err = GrammarInvalid.new(@line_number, @symbol)
                err.column_start = last_symbol.column_start
                err.column_end = rules_begin[i-1] + 1
                @errors.push(GrammarError.new(err, GrammarError.unclosed_separation))
              end
            else
              this_symbol = GrammarInvalid.new(@line_number, @symbol)
              @errors.push(GrammarError.new(this_symbol, "Syntax error: " + r.to_s))
            end
          end
          
          if this_symbol and this_symbol.type_name != :group
            start_position = rules_begin[i].nil? ? 0 : rules_begin[i]
            this_symbol.column_start = start_position
            this_symbol.column_end = start_position + r.length - 1
          end
          
          if not self.errors
            
            if add_to_group
              # if last symbol is a separation sign, add this symbol to current group
              last_symbol.add(this_symbol)
              last_symbol.column_end = this_symbol.column_end
              add_to_group = false
            else
              @expressions.push(last_symbol) if last_symbol
              last_symbol = this_symbol
            end
          else
            break
          end
        end
        
        i += 1
        
      end # END of different matching type
     
    elsif source.strip.length > 0
      # non-matching and non-empty
      @empty = false
      @errors.push(GrammarError.new(self, GrammarError.invalid_grammar))
      @column_start = 0
      @column_end = source.length - 1
    end # END of pattern matching
    
  end
  
  # return the string to use as the class name for this grammar rule
  def class_name
    camelize(symbol)
  end
  
  # return the file name for the class file 
  def file_name
    symbol + ".rb"
  end
  
  def single?
    expressions.length == 1
  end
  
  def multi_unit?
    single? && expressions.first.kind_of?(GrammarGroup)
  end
  
  def proxy?
    single? && expressions.first.kind_of?(GrammarLookup)
  end
  
  def init_expectation?
    !(expressions.length == 1 && expressions.first.kind_of?(GrammarRegexp))
  end

  # TODO: here assumed that the first expression is a literal; need to change later
  def pattern
    expressions.first.pattern
  end
  
  # list of referenced file
  def required_files
    arr = Array.new
    
    if multi_unit?
      expressions.first.choices.each do |expr|
        if !(expr.kind_of? GrammarLiteral or expr.kind_of? GrammarRegexp) 
          arr.push expr.file_name
        end
      end
    else
      self.expressions.each do |expr|
        if !(expr.kind_of? GrammarLiteral or expr.kind_of? GrammarRegexp) 
          arr.push expr.file_name
        end
      end
    end
    arr.uniq
  end
  
  def to_s
    symbol + " -> " + expressions.collect{|expr|expr.to_s}.join(", ")
  end
  
end