include Java

require 'component/explorer/explorer_leaf_node.rb'

class ExplorerModel < javax.swing.tree.DefaultTreeModel
  
  attr_accessor :root
  
  def initialize(root)
    super(root)
    @root = root
    @lookup = Hash.new
  end
  
  def update_symbols(grammar)
    @lookup = Hash.new
    symbol_folder = @root.folders[:semantics]
    symbol_folder.removeAllChildren
    grammar.semantics.keys.sort{|a,b| a.to_s <=> b.to_s}.each do |symbol|
      node = ExplorerLeafNode.new(symbol.to_s, "semantic", symbol.to_s, !grammar.symbols.has_key?(symbol))
      insertNodeInto(node, symbol_folder, symbol_folder.getChildCount)
    end
    nodeStructureChanged(symbol_folder)
  end

end