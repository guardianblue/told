include Java

require 'component/explorer/explorer_root_node.rb'
require 'component/explorer/explorer_folder_node.rb'
require 'component/explorer/explorer_leaf_node.rb'

class ExplorereNodeRenderer < javax.swing.tree.DefaultTreeCellRenderer
  def initialize()
    super()
  end
    
  def getTreeCellRendererComponent(tree, value, sel, expanded, leaf, row, hasFocus)
    super
    if value.kind_of? ExplorerRootNode
      if expanded
        setIcon $icon_library.getIcon("project")
      else
        setIcon $icon_library.getIcon("project_closed")
      end
    elsif value.kind_of? ExplorerFolderNode
      case value.name
        when "Settings"
          setIcon $icon_library.getIcon("folder_settings")
        when "Grammar"
          setIcon $icon_library.getIcon("folder_grammar")
        when "Semantics"
          setIcon $icon_library.getIcon("folder_semantics")
        when "Codes"
          setIcon $icon_library.getIcon("folder_codes")
      end
    elsif value.kind_of? ExplorerLeafNode
      if value.action_type == "semantic"
        if value.special?
          setIcon $icon_library.getIcon("code_unused")
        else
          setIcon $icon_library.getIcon("code_green")
        end
      elsif value.action_type == "settings"
        setIcon $icon_library.getIcon("settings")
      elsif value.action_type == "grammar"
        setIcon $icon_library.getIcon("code_red")
      elsif value.action_type == "code"
        setIcon $icon_library.getIcon("code_blue")
      end
    end
    
    self
  end
  
end
