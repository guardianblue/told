include Java

require 'component/syntax_tree/syntax_info_model.rb'
require 'component/syntax_tree/syntax_tree_renderer.rb'
require 'component/syntax_tree/syntax_tree_view.rb'
require 'component/syntax_tree/syntax_tree_model.rb'
require 'component/syntax_tree/syntax_tree_node.rb'

class SyntaxTreePane < javax.swing.JPanel
  include javax.swing.event.TreeSelectionListener
  
  DEFAULT_UNACTIVE_MESSAGE = "Syntax tree not available yet"
  
  attr_accessor :main_window
  attr_accessor :syntax_tree_view
  attr_accessor :tab_id
  attr_reader :icon
  attr_reader :title
  attr_reader :model
  
  def initialize(main_window)
    super()
    @main_window = main_window
    @icon = "tree"
    @title = "Syntax Tree"
    create_components
  end
  
  def activate
    @message.setVisible(false)
    @splitpane.setVisible(true)  
  end
  
  def deactivate(message = DEFAULT_UNACTIVE_MESSAGE)
    @message.setText(message)
    @message.setVisible(true)  
    @splitpane.setVisible(false)  
  end
  
  def set_node_cursor(node)
    if @last_node
      @last_node.status = :old
    end
    
    unless node.nil?
      node.status = :current
      @last_node = node
      
      # builds the tree_path manually, TreePath.new(Array) somehow doesn't work
      path_array = node.getPath
      tree_path = javax.swing.tree.TreePath.new(path_array[0])
      1.upto(path_array.length-1) do |i|
        tree_path = tree_path.pathByAddingChild(path_array[i])
      end
      
      # make the selected node visible
      @syntax_tree_view.scrollPathToVisible(tree_path)
      @syntax_tree_view.repaint
    end
    @node_table.getModel.fireTableDataChanged
    @table_scroll.revalidate
    @table_scroll.repaint
    
  end
  
  def update_table(model)
    @node_table.setModel(model)
  end
  
  # Show the corresponding syntax tree for the parsed sample code
  # root_node: top level node for the runtime
  def set_syntax_tree(root_node)
    tree_node = SyntaxTreeNode.new(SyntaxTreeNode::ROOT_NODE, root_node)
    @model = SyntaxTreeModel.new(tree_node)
    @last_node = nil
    @node_table.setModel(SyntaxInfoModel.new(nil))
    @syntax_tree_view.setModel(@model)
    @syntax_tree_view.expandAll
    activate
  end
  
  # Listener callback when user clicks the syntax tree
  def valueChanged(e)
    # locate the node being selected
    path = e.getPath
    pathCount = path.getPathCount
    if pathCount >= 1
      node = path.getPathComponent(pathCount - 1)
    else
      return
    end
      
    # create data model object for this node
    info = SyntaxInfoModel.new(node.unit)
    
    if info.valid?  
      @node_table.setModel(info)
      layout_table
      @main_window.code_panes[0].editor.reset_style
      @main_window.code_panes[0].editor.set_style(info.line_start, info.column_start, info.line_end, info.column_end)
    end
    
  end
  
  protected
  def create_components
    self.setLayout(javax.swing.BoxLayout.new(self, javax.swing.BoxLayout::PAGE_AXIS))
    
    # Tree View (Upper part)
    @message = javax.swing.JTextPane.new
    @message.setOpaque(false)
    @message.setEnabled(false)
    @message.setPreferredSize(java.awt.Dimension.new(200, 400))
    @message.setText(DEFAULT_UNACTIVE_MESSAGE)
    @syntax_tree_view = SyntaxTreeView.new
    @syntax_tree_view.setCellRenderer(SyntaxTreeRenderer.new)
    @syntax_tree_view.addTreeSelectionListener(self)
    @tree_scroll = javax.swing.JScrollPane.new(@syntax_tree_view)
    
    # Table View (Lower part)
    @node_table = javax.swing.JTable.new(SyntaxInfoModel.new(nil))
    @node_table.setShowGrid(true)
    @node_table.getTableHeader.setReorderingAllowed(false)  
    layout_table
    @table_scroll = javax.swing.JScrollPane.new(@node_table)
    
    # Split Pane
    @splitpane = javax.swing.JSplitPane.new(javax.swing.JSplitPane::VERTICAL_SPLIT, 
                                            @tree_scroll,
                                            @table_scroll)
    @splitpane.setResizeWeight(0.8)
    @splitpane.setBorder(javax.swing.BorderFactory::createEmptyBorder())
    @splitpane.setVisible(false)
    
    self.add(@message)
    self.add(@splitpane)
  end
  
  def layout_table
    @column_model = @node_table.getColumnModel 
    @column_model.getColumn(0).setPreferredWidth(100)
    @column_model.getColumn(1).setPreferredWidth(120)
  end
  
end