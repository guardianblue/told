include Java

require 'component/tokenizer/tokenizer_model.rb'

class TokenizerPane < javax.swing.JPanel
  include javax.swing.event.ListSelectionListener
  
  attr_accessor :main_window
  attr_accessor :table
  attr_accessor :tab_id
  attr_reader :icon
  attr_reader :title
  
  def initialize(main_window)
    super()
    @main_window = main_window
    @title = "Tokenizer"
    @icon = "tokens"
    create_components
  end
  
  def tokenizer=(value)
    @table.getModel.tokenizer = value
  end
  
  def deactivate
    @table.setModel(TokenizerModel.new)
  end
  
  def valueChanged(e)
     row = e.getFirstIndex
     token = @table.getModel.tokenizer.tokens[row]
     if token
       @main_window.code_panes[0].editor.reset_style
       @main_window.code_panes[0].editor.set_style(token.line_number, token.column_start, token.line_number, token.column_end)
     end
  end
  
  protected
  def create_components
    self.setLayout(javax.swing.BoxLayout.new(self, javax.swing.BoxLayout::PAGE_AXIS))
    @table = javax.swing.JTable.new(TokenizerModel.new)
    @table.getTableHeader.setReorderingAllowed(false)  
    @table.setSelectionMode(javax.swing.ListSelectionModel::SINGLE_SELECTION)
    @table.getSelectionModel.addListSelectionListener(self)
    @column_model = @table.getColumnModel 
    @column_model.getColumn(0).setPreferredWidth(300)
    @column_model.getColumn(1).setPreferredWidth(100)
    @scrollpane = javax.swing.JScrollPane.new(@table)
    self.add(@scrollpane)
  end
  
end