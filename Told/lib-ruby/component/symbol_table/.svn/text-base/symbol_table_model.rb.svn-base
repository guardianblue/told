include Java

class SymbolTableModel < javax.swing.table.AbstractTableModel
  
  def initialize(symbol_table = nil)  
    super()
    if symbol_table
      @symbol_table = symbol_table
      @symbol_table.addListener(self)
      update_value
    else
      @data = Array.new
    end
  end
  
  def symbol_table_updated
    update_value
    fireTableDataChanged
  end
  
  def update_value
    @data = @symbol_table.symbol_list.collect do |v|
      [v[1].name, v[1].type, v[1].value, v[0]]
    end
  end
  
#  def addTableModelListener(l)
#    return    
#  end
  
#  def getColumnClass(index)
#    return getValueAt(0, index).getClass()
#  end
  
  def getColumnCount
    4
  end
  
  def getColumnName(index)
    case index
      when 0
        "Symbol"
      when 1
        "Type"
      when 2
        "Value"
      when 3
        "Scope"
    end
  end
  
  def getRowCount
    @data.length
  end
  
  def getValueAt(row, col)
    @data[row][col]
  end
  
  def isCellEditable(row, col)
    false
  end
  
  def removeTableModelListener(l)
    
  end
  
  def setValueAt(value, row, col)
    
  end
  
end
