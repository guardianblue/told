# TypecheckError provides error information during type-checking stage
class TypecheckError < RuntimeError
  def self.mismatched
    "Type mismatched"
  end
  
  # Raised when trying to assigning value of different type to a variable
  def self.wrong_define(target, value)
    "Assigning <#{value}> to variable with the type <#{target}>"
  end
  
  # Raised when trying to concatenate(add) variables of different type
  def self.concat_failed(arg1, arg2)
    "Failed to concatenate <#{arg1}> with <#{arg2}>"
  end
  
end