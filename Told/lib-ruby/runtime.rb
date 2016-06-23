require 'symbol_table/symbol_table.rb'
require 'tokenizer/token_error.rb'
require 'tokenizer/tokenizer.rb'
require 'parser/parser.rb'
require 'parser/parse_error.rb'
require 'parser/main_class_error.rb'
require 'grammar/grammar_error.rb'
require 'grammar/semantic_error.rb'
require 'parser/evaluator_error.rb'
#require 'program.rb'

# The Runtime class holds all the runtime information of the designed language
class Runtime
  
  attr_reader :grammar
  
  attr_reader :tokenizer
  attr_reader :parser
  attr_reader :symbol_table
  
  attr_accessor :source
  attr_reader :root_node
  attr_reader :phase
  attr_accessor :last_node # the node that has just been typechecked/evaluated
  attr_accessor :next_node # the node that is going to be typechecked/evaluated  
  attr_accessor :top_level_class # Class name for the top level language unit, e.g. Program
  
  attr_accessor :stepthrough # run the program instantly or step through each syntax node
  
  attr_reader :input_buffer
  
  # Initialize the runtime object
  def initialize(grammar)
    @grammar = grammar
    @step_through = false
    @error = false
    @listeners = Array.new
    @input_buffer = ""
  end
  
  # Add a listener
  def add_listener(object)
    @listeners.push(object)
  end
  
  # Remove a listener
  def remove_listener(object)
    @listeners.delete(object)
  end
  
  # Notify listeners when the runtime starts
  def fire_started
    @listeners.each do |l|
      l.runtime_started
    end
  end
  
  # Notify listeners if the runtime ended normally
  def fire_finished
    @listeners.each do |l|
      l.runtime_finished
    end
  end
  
  # Notify listeners if the runtime is terminated by user
  def fire_terminated
    @listeners.each do |l|
      l.runtime_terminated
    end
  end
  
  # Notify listeners if runtime error occurred
  def fire_error
    @listeners.each do |l|
      l.runtime_error
    end
  end
  
  # Notify listeners if a stepthrough run has just finished
  def fire_stepped
    @listeners.each do |l|
      l.runtime_stepped
    end
  end
  
  # Notify listeners if a breakpoint is initiated
  def fire_breakpoint
    @listeners.each do |l|
      l.runtime_breakpoint
    end
  end
  
  # Notify listeners if the runtime is blocked awaiting input
  def fire_input
    @listeners.each do |l|
      l.runtime_input
    end
  end
  
  # Request input
  def request_input
    fire_input
    Thread.stop
    @input_buffer
  end
  
  # Provide content to input request
  def provide_input(value)
    @input_buffer = value
    run_step
  end
  
  # Shorthand method for creating all the components
  def create_components
    create_tokenizer
    create_symbol_table
    create_parser
  end
  
  # Create a symbol table for this runtime
  def create_symbol_table(value = 0)
    @symbol_table = case value
    when 0
      LexicalSymbolTable.new
    when 1
      DynamicSymbolTable.new
    else
      LexicalSymbolTable.new
    end
  end
  
  # Generate the tokenizer based on the literals defined in the grammar
  def create_tokenizer(manual_space = false)
    @tokenizer = Tokenizer.new
    if manual_space
      @tokenizer.manual_space = true
    end
    @grammar.literals.each do |literal|
      @tokenizer.add_rule(literal, Regexp.new(eval(literal)))
    end
  end
  
  # Generate the parser, and run generated codes from grammar
  def create_parser
    #puts @grammar.to_code
    @parser = Parser.new
    symbol = ""
    current_code = ""
    begin
      @grammar.codes do |key, code|
        symbol = key
        current_code = code
        @parser.instance_eval(code, symbol)
      end
    rescue ScriptError => e
      # error in user-submitted code
      @error = SemanticError.new(symbol, current_code, e.message)
      raise
    end
  end
  
  # Start the tokenize stage
  def tokenize
    @phase = "tokenize"
    @tokenizer.tokenize(source)    
  end
  
  # Start the parsing stage
  def parse
    begin
      @phase = "parse"
      @root_node = @parser.instance_eval("Program.new")
      
      @root_node.symbol_table = @symbol_table
      @root_node.runtime = self
      @root_node.parse(@tokenizer)
      
      if @tokenizer.has_next?
        raise ParseError.new(@tokenizer.peek_next, ParseError.remaining_token)
      end
      
    rescue NameError => e
      # Program class is not defined
      puts e
      @error = MainClassError.new
      raise
    end
  end
  
  # Start the evaluator stage
  def typecheck_and_evaluate
    @last_node = nil
    @next_node = nil
    @thread = Thread.new {
      begin
        fire_started
        @phase = "type-checking"
        level_debug(:runtime, "Enter phase: Type checking")
        @root_node.typecheck
        @phase = "evaluation"
        level_debug(:runtime, "Enter phase: Evaluation")
        @root_node.evaluate
      rescue StandardError => e
        #@error = e.message
        @error = EvaluatorError.new(@grammar, @phase, "#{e.backtrace}", "#{e.message}")
        fire_error
      end
      @phase = "ended"
      fire_finished
      Thread.exit
    }
  end
  
  # Terminate the runtime
  def terminate
    terminate!
    fire_terminated
  end
  
  # Terminate the runtime but do not notify listeners
  def terminate!
    if @thread
      @thread.kill
    end
  end
    
  # Return whether the runtime has been started
  def started?
    @started
  end
  
  # Return false if there is not error, return the error object otherwise
  def error
    @error
  end
  
  # Run the code by 1 syntax node
  def run_step
    if @thread.status
      @thread.wakeup
    else
      @phase = "ended"
    end
  end
    
  # Called by Language to notify the runtime the evaluator thread has just been stopped
  def pause(next_node, by_breakpoint = false)
    @last_node = @next_node
    @next_node = next_node
    if by_breakpoint
      fire_breakpoint
    elsif @stepthrough
      fire_stepped
    end
  end
  
  # Return whether this runtime is active (not ended or terminated)
  def active?
    @phase != "ended"
  end
  
end