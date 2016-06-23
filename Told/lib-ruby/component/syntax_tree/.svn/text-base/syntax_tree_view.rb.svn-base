include Java

class SyntaxTreeView < javax.swing.JTree

  def convertValueToText(value, selected, expanded, leaf, row, hasFocus)
    value.to_s
    #value.language_unit.label
  end
  
  def expandAll
    i = 0
    while (i < getRowCount) do
      expandRow(i);
      i = i + 1
    end
  end
  
end
