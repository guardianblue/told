include Java

class BlockRunner < Java::java.lang.Thread
  def initialize(&proc)
    super()
    @p = proc
  end
  def run
    @p.call
  end
end

SwingUtils = javax.swing.SwingUtilities

def SwingUtils.invoke_block_later(&proc)
  r = BlockRunner.new(&proc)
  invoke_later r
end