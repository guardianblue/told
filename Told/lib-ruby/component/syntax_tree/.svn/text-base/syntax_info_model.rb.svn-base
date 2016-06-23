include Java

class SyntaxInfoModel < javax.swing.table.AbstractTableModel
  
  attr_reader :line_start, :column_start, :line_end, :column_end
  
  def initialize(unit)  
    super()
    @static_info = ["Type", "Content", "Start", "End"]
    @data = Hash.new
    @unit = unit
    
    if @unit.nil?
      @valid = false
    else
      @valid = true
      @data["Type"] = @unit.type_label
      @data["Content"] = @unit.content
      
      if @unit.respond_to?("language_instance")
        @expressions = @unit.expressions
        @properties = @unit.properties
        # for language unit
        @line_start = @unit.token ? @unit.token.line_number : 1
        @column_start = @unit.token ? @unit.token.column_start : 0
      else
        # for tokens
        @expressions = Array.new
        @properties = Hash.new
        @line_start = @unit.line_start
        @column_start = @unit.column_start
      end
        
      node = @unit
      while !node.kind_of?(Token) do
        break unless (node.expressions && node.expressions.last)
        node = node.expressions.last
      end
      
      @line_end = node.line_number
      @column_end = node.column_end
      
      @data["Start"] = "#{@line_start} : #{@column_start + 1}"
      @data["End"] =  "#{@line_end} : #{@column_end + 1}"
    end
    
  end
  
  def addTableModelListener(l)
    return    
  end
  
  def valid?
    @valid
  end
  
#  def getColumnClass(index)
#    return getValueAt(0, index).getClass()
#  end
  
  def getColumnCount
    2
  end
  
  def getColumnName(index)
    case index
      when 0
        "Property"
      when 1
        "Value"
    end
  end
  
  def getRowCount
    if @valid
      @static_info.length + @expressions.length + @properties.length
    else
      0
    end
  end
  
  def getValueAt(row, col)
    if row < @static_info.length
      # static info
      case col
        when 0
          @static_info[row]
        when 1
          @data[@static_info[row]]
      end
    elsif row < @static_info.length + @expressions.length
      expr_index = row - @static_info.length
      case col
        when 0
          "Expressions [#{expr_index}]"
        when 1
          @expressions[expr_index].to_s
      end
    else
      prop_index = row - @static_info.length - @expressions.length
      prop = @properties.to_a[prop_index]
      case col
        when 0
          "Properties [#{prop[0]}]"
        when 1
          prop[1].to_s
        end
    end
  end
  
  def isCellEditable(row, col)
    false
  end
    
end