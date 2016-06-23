include Java

class ExplorerLeafNode < javax.swing.tree.DefaultMutableTreeNode
  
  attr_accessor :action_type, :action_detail
  
  def initialize(name, action_type, action_detail, special = false)
    super()
    @name = name
    @action_type = action_type
    @action_detail = action_detail
    @special = special
  end
  
  def toString()
    @name
  end
  
  def special=(value)
    @special = value
  end
  
  def special?
    @special
  end
  
  def getAllowsChildren()
    false
  end

  def isLeaf
    true
  end 

end