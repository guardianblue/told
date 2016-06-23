include Java

require 'component/error/error_model.rb'

class ErrorPane < javax.swing.JPanel
  
  attr_accessor :main_window
  attr_accessor :tab_id
  attr_reader :icon
  attr_reader :title
  
  def initialize(main_window)
    super()
    @main_window = main_window
    @title = "Errors"
    @icon = "error"
    create_components
  end
  
  def update(grammar)
    @model.update(grammar)
  end
  
  protected
  def create_components
    self.setLayout(javax.swing.BoxLayout.new(self, javax.swing.BoxLayout::PAGE_AXIS))
    @model = ErrorModel.new
    @table = javax.swing.JTable.new(@model)
    @table.getTableHeader.setReorderingAllowed(false)  
    @column_model = @table.getColumnModel 
    @column_model.getColumn(0).setPreferredWidth(50)
    @column_model.getColumn(1).setPreferredWidth(80)
    @column_model.getColumn(2).setPreferredWidth(300)
    @scrollpane = javax.swing.JScrollPane.new(@table)
    self.add(@scrollpane)
  end
end