include Java

class ErrorModel < javax.swing.table.AbstractTableModel
  
  def initialize()  
    super()
    @data = Array.new
  end
  
  def update(grammar)
    @data = []
    grammar.sorted_errors.each do |v|
      @data.push([v.location, v.symbol, v.description])
    end
    fireTableDataChanged
  end
  
#  def addTableModelListener(l)
#    return    
#  end
  
#  def getColumnClass(index)
#    return getValueAt(0, index).getClass()
#  end
  
  def getColumnCount
    3
  end
  
  def getColumnName(index)
    case index
      when 0
        "Location"
      when 1
        "Symbol"
      when 2
        "Description"
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
