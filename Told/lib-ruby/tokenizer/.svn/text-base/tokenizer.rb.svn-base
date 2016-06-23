require 'tokenizer/token_rule.rb'
require 'tokenizer/token_error.rb'
require 'tokenizer/token.rb'

# The Tokenizer class tokenizes program codes according to the language grammar
class Tokenizer

  attr_accessor :tokens, :manual_space
  
  # Initialize a Tokenizer object.
  # If +verbose+ is true, the list of tokens will be printed out after calling Tokenizer#tokenize
  def initialize(verbose = false)
    @rules = Hash.new
    @tokens = Array.new
    @next_index = 0
    @error = nil
    @verbose = verbose
    @manual_space = false
  end
  
  def error?
    @error
  end

  # Adds a tokenizing rule
  #
  # Important: If the regex contains groups, please use Non-capturing groups instead +(?:pattern)+
  def add_rule(name, regex)
    level_debug(:tokenizer, "Added Rule[#{name}] : #{regex}")
    @rules[name] = TokenRule.new(name, regex) 
  end

  # Removes a tokenizing rule
  def remove_rule(name)
    @rules.delete name
  end

  # Returns whether a previous token is available
  def has_prev?
    @next_index > 0
  end

  # Returns whether a next token is available
  def has_next?
    @next_index < token_count
  end
  
  # Returns the next token
  def next
    token = next!
    forward
    token
  end

  # Same as next, but will not advance the token index
  def next!
    if has_next?
      self.tokens[@next_index]
    end
  end
  
  # Experimental support for infix grammar. Mark current index for rollback.
  def mark
    @mark = @next_index
  end
  
  # Experimental support for infix grammar. Rollback to previously marked index
  def rollback
    @next_index = @mark
  end

  # Advances the tokenizer
  def forward
    if has_next?
      @next_index += 1
    end
  end

  # Rewinds the tokenizer
  def rewind
    if has_prev? 
      @next_index -= 1
    end
  end

  # Resets the tokenizer so that the first token will be return when next is called again
  def reset
    @next_index = 0
  end

  # Tokenizes the given string. Throws TokenizerError.
  def tokenize(string)
    
    # Join all token rules to form a regular expression
    rules_arr = rules.to_a.collect{|r| r[1]}
    rxp = Regexp.new rules_arr.collect{|r| r.regex.source}.join("|"), Regexp::EXTENDED
    rxp_ignore = /\s+/
    
    line_number = 1
    string.each_line do |line|
      
      column_number = 0
      
      # remove trailling white spaces
      line = line.sub(/\s+$/, "")  
      
      while column_number < line.length do
        
        unless @manual_space
          # ignore any white space found
          match_ignore = rxp_ignore.match line[column_number..-1]
          if match_ignore and match_ignore.begin(0) == 0
            column_number += match_ignore.end(0)
          end
        end
        
        match = rxp.match line[column_number..-1]
        if match and match.begin(0) == 0
          if match.end(0) == 0
            # infinite loop!
            @error = InfiniteTokenError.new
            raise @error
          else            
            # found
            tokens.push Token.new(match[0], line_number, column_number)
            column_number += match.end(0)
          end
        else
          # TODO: Capture the exception
          @error = TokenError.new(line_number, column_number) 
          raise @error
        end
      end
      
      line_number += 1
      
    end
    
    #self.tokens = string.gsub(omit_rxp, " ").scan(valid_rxp)
    
    if @verbose
      $stderr.puts "Tokenizer Result:"
      self.tokens.each do |t|
        $stderr.print "  "
        $stderr.puts t.label
      end
      $stderr.puts "--- END ---\n"
    end
    
  end

  # Returns the number of total tokens, excluding the omitted ones
  def token_count
    self.tokens.length
  end

  alias peek_next next!

  private
  def rules
    @rules
  end
end  
