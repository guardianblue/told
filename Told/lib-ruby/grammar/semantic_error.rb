class SemanticError < RuntimeError
  
  def initialize(symbol, code, raw_message)
    @symbol = symbol
    @code = []
    code.each_line do |line|
      @code.push(line)
    end
    @raw_message = raw_message
    process_raw_message
  end
  
  def to_s
    
    if @information
      "Semantic Error at [#{@symbol}:#{@line_number}]\n>> #{@message}\n#{problem_code_with_number}"
    else
      "Semantic Error at [#{@symbol}]"
    end
  end
  
  def problem_code
    @code[@line_number - 1]
  end
  
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
  def process_raw_message
    match_data = /([a-zA-Z][a-zA-Z_0-9]*):(\d+)\:(.*)/.match(@raw_message)
    if match_data
      @information = true
      @line_number = match_data[2].to_i
      @message = match_data[3]
    else
      @information = false
    end
  end
end