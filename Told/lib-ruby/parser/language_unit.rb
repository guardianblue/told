# Teaching-Oriented Language Development Environment (TOLD)
#
# This is the API File for the classes that you need to use in the Semantic Panel
#
# = Important Classes
# * SymbolTable
# * LanguageUnit
# * MultiUnit
#
# You are also encouraged to check out the source code of the following classes
# * DynamicSymbolTable
# * LexicalSymbolTable
# * Runtime 

require 'parser/expectation.rb'
require 'parser/parse_error.rb'
require 'parser/typecheck_error.rb'

# Superclass for all parsable unit of the language
#
# When you click on a semantic node in the Project Explorer (left panel),
# The Semantic Panel will be opened. There you can edit the evaluation and type-checking methods of that node.
#
# IMPORTANT NOTE: the first call +super+ (in both +evaluate+ and +typecheck+ methods) should not be modified.
# It is responsible for IDE interaction. If you delete this line, features such as the parse tree, stepthrough will be broken
#
# == Evaluation
# Define +evaluate+ instance method to provide the result of evaluation
# 
#   def evaluate
#     super
#     expressions[1].evaluate + expressions[3].evaluate
#   end
#
# == Type-checking
# Define the +typecheck+ instance method to provide the type of this element,
# or raise TypecheckError if types of subsequent expressions does not agree.
#   def typecheck
#     super
#     if expressions[1].typecheck == "integer" and expressions[3].typecheck == "integer"
#       "integer"
#     else
#       raise TypecheckError, TypecheckError.concat_failed(expressions[1].type_check, expressions[3].type_check)
#     end
#   end

class LanguageUnit
  
  attr_accessor :expecting, :expressions, :root, :token, :runtime, :properties
  
  # Determine whether this class is sub-class of LanguageUnit or not
  def self.language_class
    true
  end
  
  # Determine whether this object is an instance of LanguageUnit
  def language_instance
    true
  end
  
  # Set the symbol table object for the language unit
  def symbol_table=(value)
    if parent
      root.symbol_table = value
    else
      @symbol_table = value
    end
  end
  
  # Retrieve the symbol table object
  def symbol_table
    if @parent
      root.symbol_table
    else
      @symbol_table
    end
  end
  
  # Set the link to the runtime environment object
  def runtime=(value)
    if parent
      root.runtime = value
    else
      @runtime = value
    end
  end
  
  # Retrieve runtime environment object
  def runtime
    if @parent
      root.runtime
    else
      @runtime
    end
  end
    
  # Pattern to be used in the +test+ method
  def self.pattern
    Regexp.new('')
  end
  
  # Test if a token could be (the start of) this LanguageUnit
  def self.test(token)
    if (m = self.pattern.match(token.content))
      if m[0] == token.content
        return true
      end
    end
    false
  end
  
  # Parent expression. If this is the root node of the AST, the value will be nil
  def parent=(value)
    @parent = value
    if value
      @root = @parent.root
    else
      @root = self
    end
  end
  
  def parent
    @parent
  end
  
  # Instansiate this LanguageUnit.
  def initialize
    self.expressions = []
    self.expecting = self.init_expecting
    @properties = Hash.new
    @parent = nil
    @root = self
    @paused = false
  end

  # Returns the initial +expecting+ array
  # Used in the parsing stage
  def init_expecting
    [Expectation.new(self.class.pattern)]
  end
  
  # Parse this language unit will the given tokenizer
  def parse(tokenizer)

    # terminate condition
    terminate = (expecting.empty? or (not tokenizer.has_next?))
    next_expecting = expecting.shift
  
    # Parse until terminate condition fulfilled
    while not terminate do
      
      level_debug(:parser, "#{to_s} Expecting [#{expecting.collect{|item| item.to_s}.join(", ")}] \n>> Current: [" + next_expecting.to_s + "]")
      level_debug(:parser, ">> Next token: ["+ tokenizer.peek_next.content.to_s + "]")
      
      if next_expecting.value.kind_of? Regexp
        
        # If it is an explicit regular expression, parse and continue
        if tokenizer.peek_next.content =~ next_expecting.value
          level_debug(:parser, "<#{to_s}> Regexp: matched")
          # push this token  to expressions array
          self.expressions.push(tokenizer.next)
        
          # Consume the next_expecting token if its modifier is once or optional
          if [:once, :optional].include? next_expecting.modifier
            next_expecting.consume
          end
        else
          level_debug(:parser, "<#{to_s}> Regexp: mismatched")
          if next_expecting.modifier == :once
            # Token mismatched, raises ParseError
            raise ParseError.new(tokenizer.peek_next, ParseError.mismatched(self.class, tokenizer.peek_next.content))
          else 
            # This unit is optional, or cannot be further expanded. Consume.
            next_expecting.consume
          end
        end
      elsif next_expecting.value.kind_of?(Class) and next_expecting.value.new.kind_of?(LanguageUnit)
        
        # Test if the next token agrees with this language unit
        if next_expecting.value.test(tokenizer.peek_next)
          level_debug(:parser, "<#{to_s}> #{next_expecting.value.to_s}: matched")
          # Instanstiate the language unit and store it in +expressions+ array
          expression = next_expecting.value.new
          expression.parent = self
          expression.token = tokenizer.peek_next
          expression.parse(tokenizer)
          self.expressions.push(expression)
          if [:once, :optional].include? next_expecting.modifier
            next_expecting.consume
          end
        else
          level_debug(:parser, "<#{to_s}> #{next_expecting.value.to_s}: mismatched")
          if next_expecting.modifier == :once
            # Token mismatched, raises ParseError
            raise ParseError.new(tokenizer.peek_next, ParseError.mismatched(next_expecting.value, tokenizer.peek_next.content)) 
          else
            # This unit is optional, or cannot be further expanded. Consume.
            next_expecting.consume
          end
        end
      else
        # Unknown type, raise exception
        raise ParseError.new(tokenizer.peek_next, ParseError.unknown_type(next_expecting.value))
      end # end-if
    
      # Get next expecting if the current one is consumed
      if next_expecting.consumed?
        level_debug(:parser, "<#{to_s}> Consumed [" + next_expecting.value_label + "]")
        next_expecting = expecting.shift
      end
    
      terminate = ((not next_expecting) or (not tokenizer.has_next?))
    
    end
  
    if next_expecting and next_expecting.modifier == :once
      raise ParseError.new(nil, ParseError.no_more_tokens(next_expecting))
    end  
  
  end
  
  # Evaluates this language unit, provides linkage to IDE features
  # Edit this method in the Semantic Panel to provide the result as this node is being evaluated
  def evaluate(context = {})
    if runtime.stepthrough
      if @paused
        # control is resumed from the runtime, do nothing and let subclasses do their jobs
      else
        # pass the control back to runtime, until the user press "step through" again
        level_debug(:runtime, "Evaluating #{to_s}")
        pass_control
      end
    else
      # even if it is not stepthrough, pass the thread to avoid infinite loop (terminated by gui)
      level_debug(:runtime, "Evaluating #{to_s}")
      runtime.pause(self)
      #Thread.pass
    end
    
  end
  
  # Check the type of this language unit, provides linkage to IDE features
  # Edit this method in the Semantic Panel to provide the result of checking the type of this language unit
  def typecheck(content = {})
    if runtime.stepthrough
      if @paused
        # control is resumed from the runtime, do nothing and let subclasses do their jobs
      else
        # pass the control back to runtime, until the user press "step through" again
        level_debug(:runtime, "Type checking #{to_s}")
        pass_control
      end
    else
      # even if it is not stepthrough, pass the thread to avoid infinite loop (terminated by gui)
      level_debug(:runtime, "Type checking #{to_s}")
      runtime.pause(self)
      #Thread.pass
    end
  end
  
  # Short hand method for evaluating all children expressions one by one
  def evaluate_all(context = {})
    result = nil
    expressions.each do |expr|
      if expr.kind_of? LanguageUnit
        result = expr.evaluate(context)
      end
    end
    result
  end
  
  # Short hand method for evaluating the first child expressions
  # Useful for MultiUnit
  def evaluate_first(context ={})
    expressions.first.evaluate(context)
  end
  
  # Short hand method for type-checking all children expressions one by one
  def typecheck_all(context = {})
    result = nil
    expressions.each do |expr|
      if expr.kind_of? LanguageUnit
        result = expr.typecheck(context)
      end
    end
    result
  end
  
  # Short hand method for type-checking the first child expressions
  # Useful for MultiUnit
  def typecheck_first(context = {})
    expressions.first.typecheck(context)
  end
  
  # provide a human-readable list of contents in the expressions array
  def list_expressions
    level_debug(:runtime, "Listing expressions <#{self.to_s}>")
    expressions.each_with_index do |expr, i|
      level_debug(:runtime, " - expressions[#{i}]: #{expr.content}")
    end
  end
  
  # Provides the string to be shown in the parse tree. 
  def content
    self.class.to_s
  end
  
  # Alias for +content+
  def type_label
    self.class.to_s
  end
  
  # Alias for +content+
  def to_s
    content
  end
  
  # Initiate a breakpoint during run mode. You can then stepthrough the code or continue until end of program.
  def breakpoint
    pass_control(true)
  end
  
  # Class method to return the effective part of class name
  # removing the namespace part due to running the parser on an object-level context
  def self.to_s
    super.sub(/.*?::/, "")
  end
  
  protected
  def pass_control(by_breakpoint = false)
    @paused = true
    runtime.pause(self, by_breakpoint)
    Thread.stop
  end
  
end