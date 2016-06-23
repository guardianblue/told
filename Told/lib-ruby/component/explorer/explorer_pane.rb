include Java

require 'component/explorer/explorer_model.rb'
require 'component/explorer/explorer_leaf_node.rb'
require 'component/explorer/explorer_root_node.rb'
require 'component/explorer/explorer_tree.rb'
require 'component/explorer/explorer_node_renderer.rb'

class ExplorerPane < javax.swing.JPanel
  include java.awt.event.MouseListener
  include java.awt.event.KeyListener
    
  attr_accessor :main_window
  attr_accessor :model
  attr_accessor :tab_id
  attr_reader :icon
  attr_reader :title
  
  def initialize(main_window)
    super()
    @main_window = main_window
    @title = "Project"
    @icon = "project"
    create_components
  end
  
  def create_components
    self.setLayout(java.awt.BorderLayout.new)
    @root_node = ExplorerRootNode.new
    @model = ExplorerModel.new(@root_node)
    @tree = ExplorerTree.new(@model)
    @tree.setCellRenderer(ExplorereNodeRenderer.new)
    @tree.expand_all
    @tree.addMouseListener(self)
    @tree.addKeyListener(self)
    @scrollpane = javax.swing.JScrollPane.new(@tree)
    self.add(@scrollpane, java.awt.BorderLayout::CENTER)
  end
  
  def update_symbols(grammar)
    @model.update_symbols(grammar)
    @tree.expand_all
  end
  
  # Handles mouse event
  def mousePressed(e)
    if (e.getClickCount == 2)
    # locate the node being selected
      act_on_selected_node
    end
  end
  def mouseEntered(e)
  end
  def mouseExited(e)
  end
  def mouseReleased(e)
  end
  def mouseClicked(e)
  end  
  
  # Handles Key events
  def keyPressed(e)
  end
  def keyReleased(e)
  end
  def keyTyped(e)
    key = " "
    key[0] = e.getKeyChar
    case key
    when "\n"
      # enter key
      act_on_selected_node
    end
  end
  
  protected
  def act_on_selected_node
    path = @tree.getSelectionPath
    if path
      pathCount = path.getPathCount
      if pathCount >= 1
        node = path.getPathComponent(pathCount - 1)
      else
        return
      end
      act_on_node(node)
    end
  end
  
  def act_on_node(node)
    if node.kind_of?(ExplorerLeafNode)
      case node.action_type
        when "settings"
          @main_window.show_settings
        when "semantic"
          @main_window.show_semantic_editor(node.action_detail)
        when "grammar"
          @main_window.show_grammar_pane
        when "code"
          @main_window.show_code_pane
      end
    end
  end
      
end