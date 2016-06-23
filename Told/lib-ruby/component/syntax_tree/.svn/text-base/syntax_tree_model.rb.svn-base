include Java

class SyntaxTreeModel < javax.swing.tree.DefaultTreeModel
  
  def initialize(root)
    super(root)
    @root = root
  end
  
  def lookup(language_unit)
    @root.lookup[language_unit]
  end
    
end