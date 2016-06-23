include Java

require 'component/editor/editor.rb'

class SemanticPane < javax.swing.JPanel
  include javax.swing.event.DocumentListener
  
  attr_accessor :main_window
  attr_accessor :editors
  attr_accessor :tab_id
  attr_reader :icon
  attr_reader :title
    
  def initialize(main_window, title)
    super()
    @main_window = main_window
    @title = title
    @icon = "code_green"
    @saved = true
    create_components
  end
  
  def changedUpdate(e)
    changed
  end
  
  def insertUpdate(e)
    changed
  end
  
  def removeUpdate(e)
    changed
  end
  
  def saved?
    @saved
  end
  
  def project_saved
    @saved = true
  end
  
  protected
  def changed
    @main_window.changed(self)
    @saved = false
  end
  
  def create_components
    self.setLayout(javax.swing.BoxLayout.new(self, javax.swing.BoxLayout::PAGE_AXIS))
    
    @editors = Hash.new
    @scrollpanes = Hash.new
    
    @editors[:typechecking] = Editor.new
    @scrollpanes[:typechecking] = javax.swing.JScrollPane.new(@editors[:typechecking], 
                                              javax.swing.JScrollPane::VERTICAL_SCROLLBAR_ALWAYS, 
                                              javax.swing.JScrollPane::HORIZONTAL_SCROLLBAR_ALWAYS)
                                              
    @editors[:evaluation] = Editor.new
    @scrollpanes[:evaluation] = javax.swing.JScrollPane.new(@editors[:evaluation], 
                                              javax.swing.JScrollPane::VERTICAL_SCROLLBAR_ALWAYS, 
                                              javax.swing.JScrollPane::HORIZONTAL_SCROLLBAR_ALWAYS)
    
    @editors.each_value do |editor|
      editor.add_document_listener(self)
    end
    
    @splitpane = javax.swing.JSplitPane.new(javax.swing.JSplitPane::VERTICAL_SPLIT, 
                                            @editors[:typechecking],
                                            @editors[:evaluation])
    @splitpane.setBorder(javax.swing.BorderFactory::createEmptyBorder())
    @splitpane.setResizeWeight(0.5)
    self.add(@splitpane)
  end
  
end