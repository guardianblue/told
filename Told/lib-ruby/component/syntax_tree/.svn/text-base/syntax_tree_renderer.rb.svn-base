include Java

require 'component/syntax_tree/syntax_tree_node.rb'

class SyntaxTreeRenderer < javax.swing.tree.DefaultTreeCellRenderer
  
  def initialize()
    super()
  end
    
  def getTreeCellRendererComponent(tree, value, sel, expanded, leaf, row, hasFocus)
    super
    
    if value.kind_of?(SyntaxTreeNode)
      if value.multi?
        setIcon $icon_library.getIcon("multi")
      elsif value.token?
        setIcon $icon_library.getIcon("token")
      elsif leaf
        setIcon $icon_library.getIcon("terminal")  
      else
        setIcon $icon_library.getIcon("block")  
      end
    
      case value.status
        when :fresh
          #setForeground(java.awt.Color.black)
        when :current
          setForeground(java.awt.Color.red)        
        when :old
          setForeground(java.awt.Color.gray)
      end
    
    end
    
    self
  end
  
end
