# Provides error information for errors produced in evaluation stage.
# As the error is very likely due to user-definied codes, 
# this class will try to locate the source file and output a formatted version of error information.
class EvaluatorError < RuntimeError
  
  # Initialize an EvaluatorError object
  def initialize(grammar, phase, backtrace, message)
    @grammar = grammar
    @backtrace = backtrace
    @message = message
    @phase = phase
    process_error
    if @information
      # check if there really is such symbol
      if @grammar.symbols.key?(@symbol)
        @code = []
        @grammar.symbol_code(@symbol).each_line do |line|
          @code.push(line)
        end
      else
        @information = false
      end
    end    
  end
  
  # Detailed information
  def to_s
    if @information
      "Runtime Error [#{@phase}] at [#{@symbol}:#{@line_number}]\n>> #{@message}\n#{problem_code_with_number}"
    else
      "Runtime Error [#{@phase}]: #{@backtrace}"
    end
  end
  
  # Return a formated version of the buggy code with line numbers
  def problem_code_with_number(proximity = 3)
    first_line = @line_number - proximity - 1
    if first_line < 0
      first_line = 0
    end
    last_line = @line_number + proximity - 1
    if last_line >= @code.length
      last_line = @code.length - 1
    end
    space = last_line.to_s.length
    result = ""
    first_line.upto(last_line) do |i|
      result += "#{(i+1) == @line_number ? "*" : " "}#{(i+1).to_s.rjust(space)} #{@code[i]}"
    end
    result
  end
  
  protected
  def process_error
    # split the backtrace call by call, and find if there is user-defined codes
    @backtrace.split(/`[^']*'/).each_with_index do |line, i|
      match_data = /^([a-zA-Z][a-zA-Z_0-9]*)\:(\d+)\:in/.match(line)
      if match_data
        @information = true
        @symbol = match_data[1]
        @line_number = match_data[2].to_i
        break
      else
        @information = false
      end
    end
  end
  
end