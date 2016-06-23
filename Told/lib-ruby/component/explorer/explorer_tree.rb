include Java

class ExplorerTree < javax.swing.JTree

  def expand_all
    i = 0
    while (i < getRowCount) do
      expandRow(i);
      i = i + 1
    end
  end

end