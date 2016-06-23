include Java
include_class "hk.edu.cuhk.cse.told.CaptureListener"

require 'util/block_runner.rb'
require 'component/toggle_flat_button.rb'

class ConsoleView < Java::javax.swing.JTextPane
  
  include CaptureListener
  
  DEFAULT_MAX_LINE = 500
  
  attr_accessor :max_line, :scroll_lock, :doc
  attr_reader :font
  
  def initialize(limit = DEFAULT_MAX_LINE)
    super()
    @max_line = limit
    @scroll_lock = false
    
    @doc = getStyledDocument
    
    @font = java.awt.Font.new("Monospaced", java.awt.Font::PLAIN, 12)        
    
    @styles = Hash.new
    
    @styles[:shared] = javax.swing.text.SimpleAttributeSet.new
    javax.swing.text.StyleConstants.setFontFamily(@styles[:shared], @font.getFamily());
    javax.swing.text.StyleConstants.setFontSize(@styles[:shared], @font.getSize()); 
      
    @styles[:standard] = javax.swing.text.SimpleAttributeSet.new(@styles[:shared])
    javax.swing.text.StyleConstants.setForeground(@styles[:standard], java.awt.Color.black)
    
    @styles[:highlight] = javax.swing.text.SimpleAttributeSet.new(@styles[:shared])
    javax.swing.text.StyleConstants.setForeground(@styles[:highlight], java.awt.Color.red)
    
    @styles[:input] = javax.swing.text.SimpleAttributeSet.new(@styles[:shared])
    javax.swing.text.StyleConstants.setForeground(@styles[:input], java.awt.Color.blue)
    
    @doc.setCharacterAttributes(0, @doc.getLength + 1, @styles[:shared], false);

  end
  
  def append_standard_text(text)
    append_style_text(text)
  end
  
  def append_highlight_text(text)
    append_style_text(text, :highlight)
  end
  
  def append_input_text(text)
    append_style_text(text, :input)
  end
  
  protected
  def append_style_text(text, style = :standard)
    @doc.insertString(@doc.getLength, text, @styles[style])
    assert_limit
    unless @scroll_lock
      SwingUtils.invoke_block_later do
        scroll_to_end
      end
    end
  end
  
  def getFullText
    @doc.getText(0, @doc.getLength)
  end
  
  def assert_limit
    line_index = [0]
    pos = 0
    getFullText.each_line do |line|
      line_index.push pos
      pos += line.length
    end
    if line_index.length > @max_line
      @doc.remove(0, line_index[line_index.length - @max_line])
    end
  end
  
  def scroll_to_end
    setCaretPosition(@doc.getLength)
  end
  
  def contentCaptured(content, warning)
    # Listener callback for STDOUT and STDERR redirection
    if warning
      append_highlight_text(content)
    else
      append_standard_text(content)
    end
  end
  
end