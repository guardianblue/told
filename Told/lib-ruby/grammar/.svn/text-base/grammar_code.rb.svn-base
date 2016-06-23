# Logical object to store source code information of a grammar element

require 'grammar/semantic.rb'
#require 'grammar/grammar_group.rb'
require 'grammar/grammar_literal.rb'
require 'grammar/grammar_lookup.rb'
require 'grammar/grammar_regexp.rb'

class GrammarCode
  
  attr_reader :grammar_symbol
  attr_reader :segments
  attr_reader :self_type
  attr_accessor :parent_type
  attr_accessor :header
  attr_accessor :requirement
  
  @@namespace = "Told"
  
  def self.namespace
    @@namespace
  end
    
  # Generate codes for a particular grammar symbol
  # Default semantic will be used if not supplied
  def initialize(symbol, semantic = Semantic.new)
    @symbol = symbol
    @semantic = semantic
    @segments = Hash.new
    @self_type = @symbol.class_name
    @header = ""
    @requirement = ""
    generate
  end
  
  def semantic=(value)
    @semantic = value
    regenerate
  end

  def regenerate
    @header = ""
    @requirement = ""
    @segments.clear
    generate
  end
  
  def generate
    
    @header = comment(@symbol.file_name)
    
    # generate the list of referenced files
    @requirement = create_requirement([(@symbol.multi_unit? ? "multi_unit.rb" : "language_unit.rb"),
                                      'expectation.rb'] + 
                                      @symbol.required_files)
    
    if @symbol.multi_unit?
      # handles multi-unit symbol
      @parent_type = "MultiUnit"
      
      # enumerate the possible choices of a multi_unit
      possible_units = "[\n" +
                        indent(@symbol.expressions.first.choices.collect{|expr| expr.referenced_name}.join(",\n")) + "\n" +
                        "]\n"
      @segments[:possible] = create_method("self.possible_units", possible_units)       
      
    else
      # handles normal symbol
      @parent_type = "LanguageUnit"
      
      # testing routine
      if [:literal, :regexp].include?(@symbol.expressions.first.type_name)
        # pattern-based testing
        @segments[:test] = create_method("self.pattern", @symbol.pattern) 
      else
        @segments[:test] = create_method("self.test(token)", "#{@symbol.expressions.first.referenced_name}.test(token)")
      end
      
      if @symbol.init_expectation?
        # expectation array
        exp_seg = Array.new
        @symbol.expressions.each do |expr|
          seg = "Expectation.new("
          if expr.kind_of?(GrammarLookup)
            seg += camelize(expr.symbol)
          #elsif expr.kind_of?(GrammarGroup)
            # TODO: generate anonymous multiunit class
            #seg += "AdHocMulti"
          elsif expr.kind_of? GrammarLiteral
            seg +=  expr.literal
          elsif expr.kind_of? GrammarRegexp
            seg += expr.regexp_source
          end
          if expr.modifier != :once
            seg += ", :" + expr.modifier.to_s
          end
          seg += ")"
          exp_seg.push(seg)
        end
        
        init_expecting = "[\n" +
                         indent(exp_seg.join(",\n")) + "\n" +
                         "]\n"
        @segments[:expecting] = create_method("init_expecting", init_expecting)
      end
    end
                                      
    @segments[:evaluate] = create_method("evaluate(context = {})", @semantic.evaluation)
    @segments[:typecheck] = create_method("typecheck(context = {})", @semantic.typechecking)

  end
  
  def to_s
    @header + br +
    comment(@requirement) + br +
    "class " + @self_type + " < " + @parent_type + "\n" +
    sorted_segments.collect{ |seg|
      indent(seg.last)
    }.join(br) + "\n" +  
    "end\n"
  end
  
  def sorted_segments
    @segments.sort do |a,b|
      sort_order.index(a.first) <=> sort_order.index(b.first)
    end
  end
  
  protected
  def sort_order
    [
      :test,
      :possible,
      :expecting,
      :parse,
      :evaluate,
      :typecheck
    ]  
  end
  
  def create_requirement(dependencies)
    dependencies.collect{|dep|
      "require 'parser/" + dep + "'"
    }.join("\n") + "\n"
  end
  
  def create_method(method_name, content)
    "def " + method_name + "\n" +
    indent(content) + "\n" + 
    "end"
  end
  
  def indent(source, times = 1)
    source.split("\n").collect{|s| ("  " * times) + s }.join("\n")
  end
  
  def comment(source)
    source.split("\n").collect{|s| "# " + s }.join("\n")
  end
  
  def camelize(s)
    s.to_s.gsub(/\/(.?)/) { "::" + $1.upcase }.gsub(/(^|_)(.)/) { $2.upcase }
  end
  
  def br
    "\n\n"
  end
    
end