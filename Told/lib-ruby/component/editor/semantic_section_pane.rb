include Java

require 'component/editor/editor.rb'

class SemanticSectionPane < javax.swing.JPanel
  
  def initialize(semantic_pane, title)
    super()
    @semantic_pane = semantic_pane
    @title = title
    
    create_components
    
  end
  
  
  protected
  def create_components
    
  end
  
end