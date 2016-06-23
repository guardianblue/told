class Semantic
  attr_accessor :symbol_name
  attr_accessor :evaluation
  attr_accessor :typechecking
  attr_accessor :user_defined
  
  def initialize(symbol_name)
    @symbol_name = symbol_name
    @typechecking = "# type checking\nsuper\ntypecheck_all\n"
    @evaluation = "# evaluation\nsuper\nevaluate_all\n"
    @user_defined = ""
  end
  
  def size
    @evaluation.length + @typechecking.length
  end
end