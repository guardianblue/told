include Java
require 'tokenizer/tokenizer.rb'

class TokenizerModel < javax.swing.table.AbstractTableModel
  
  COLUMN_NAMES = ["Location", "Content"]
  
  def initialize(tokenizer = Tokenizer.new)  
    super()
    @tokenizer = tokenizer
  end
  
  def tokenizer=(value)
    @tokenizer = value
    fireTableDataChanged
  end
  
  def tokenizer
    @tokenizer
  end
    
  def getColumnCount
    COLUMN_NAMES.length
  end
  
  def getColumnName(index)
    COLUMN_NAMES[index]
  end
  
  def getRowCount
    if @tokenizer
      @tokenizer.tokens.length
    else
      0
    end
  end
  
  def getValueAt(row, col)
    t = @tokenizer.tokens[row]
    if col == 0
      t.location
    elsif col == 1
      t.content
    else
      ""
    end
  end
  
  def isCellEditable(row, col)
    false
  end
  
  def removeTableModelListener(l)
    
  end
  
  def setValueAt(value, row, col)
    
  end
  
end
