include Java

require 'component/symbol_table/symbol_table_model.rb'

class SymbolTablePane < javax.swing.JPanel
  
  attr_accessor :main_window
  attr_accessor :symbol_view
  attr_accessor :tab_id
  attr_reader :icon
  attr_reader :title
  
  def initialize(main_window)
    super()
    @main_window = main_window
    @title = "Symbol Table"
    @icon = "table"
    create_components
  end
  
  def deactivate
    self.symbol_table = nil
  end
  
  def symbol_table=(value)
    @symbol_table = value
    @symbol_view.setModel(SymbolTableModel.new(@symbol_table))
  end
  
  def symbol_table
    @symbol_table
  end
  
  protected
  def create_components
    self.setLayout(javax.swing.BoxLayout.new(self, javax.swing.BoxLayout::PAGE_AXIS))
    @symbol_view = javax.swing.JTable.new(SymbolTableModel.new(nil))
    @symbol_view.getTableHeader.setReorderingAllowed(false)  
    @scrollpane = javax.swing.JScrollPane.new(@symbol_view)
    self.add(@scrollpane)
  end
  
end