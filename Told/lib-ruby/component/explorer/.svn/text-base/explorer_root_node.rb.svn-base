include Java

require 'component/explorer/explorer_folder_node.rb'
require 'component/explorer/explorer_leaf_node.rb'

class ExplorerRootNode < javax.swing.tree.DefaultMutableTreeNode
  
  attr_accessor :folders
  
  def initialize
    super()
    @folders = Hash.new
    @folders[:setting] = ExplorerFolderNode.new("Settings")
    @folders[:setting].add(ExplorerLeafNode.new("Project Settings", "settings", "0"))
    
    @folders[:grammar] = ExplorerFolderNode.new("Grammar")
    @folders[:grammar].add(ExplorerLeafNode.new("Definition", "grammar", "0"))
    
    @folders[:semantics] = ExplorerFolderNode.new("Semantics")
    @folders[:codes] = ExplorerFolderNode.new("Codes")
    @folders[:codes].add(ExplorerLeafNode.new("Sample Code", "code", "0"))
    
    @folder_order = [:setting, :grammar, :semantics, :codes]
    
    @folder_order.each do |item|
      self.add(@folders[item])
    end    
  end
  
  def toString()
    "Project"
  end
  
  def getRoot()
    self
  end
 
  def getAllowsChildren()
    true
  end

  def isLeaf
    false
  end 

end