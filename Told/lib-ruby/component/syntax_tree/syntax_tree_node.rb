include Java

class SyntaxTreeNode < javax.swing.tree.DefaultMutableTreeNode
  
  ROOT_NODE = nil
  
  attr_accessor :parent, :children, :unit, :status, :lookup

  # Create a SyntaxTreeModel from a LanguageUnit
  def initialize(parent, unit)
    super()
    @unit = unit
    
    if parent.nil?
      @root = self
      @lookup = Hash.new
    else
      @root = parent.getRoot
      @lookup = @root.lookup
    end
    @lookup[unit] = self
    @status = :fresh
    
    unless @unit.nil?
      if @unit.respond_to?("language_instance")
        @unit.expressions.each do |child|
          add(self.class.new(self, child))
        end
      end
    end
  end
  
  def multi?
    if @unit.nil?
      return false
    else
      return @unit.respond_to?("multi_instance")
    end
  end
  
  def token?
    return @unit.respond_to?("token_instance")
  end
 
  def getRoot
    @root
  end
  
  def isLeaf(node)
    node.children.empty?
  end

  def to_s
    if @unit.respond_to?("language_instance")
      @unit.to_s
    else
      "Token"
    end
  end
  
end