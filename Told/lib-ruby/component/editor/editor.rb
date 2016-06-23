include Java
include_class "hk.edu.cuhk.cse.told.component.SyntaxHighlightEditor"
include_class "hk.edu.cuhk.cse.told.component.LineNumberPanel"

class Editor < javax.swing.JPanel
  include java.awt.event.ActionListener
  
  ANNOTATION = "annotation"
  
  FONT_FAMILY = "Monospaced"
  FONT_SIZE = 12
  FONT_STYLE = java.awt.Font::PLAIN
  
  REPLACE_STYLE = true
  PRESERVE_STYLE = false
    
  def initialize()
    super()
    
    setLayout(java.awt.BorderLayout.new)
    setBorder(javax.swing.BorderFactory::createLoweredBevelBorder())
    
    @editor = SyntaxHighlightEditor.new
    @editor.setFont(java.awt.Font.new(FONT_FAMILY, FONT_STYLE, FONT_SIZE))
    
    
    @scrollpane = javax.swing.JScrollPane.new(@editor, 
                                              javax.swing.JScrollPane::VERTICAL_SCROLLBAR_ALWAYS, 
                                              javax.swing.JScrollPane::HORIZONTAL_SCROLLBAR_ALWAYS)
    @scrollpane.setBorder(javax.swing.BorderFactory::createEmptyBorder())
    @numberpane = LineNumberPanel.new(@editor, @scrollpane)
    @editor.setLineNumberPanel(@numberpane)
    
    add(@numberpane, java.awt.BorderLayout::WEST)
    add(@scrollpane, java.awt.BorderLayout::CENTER)
    
    #setEditorKit(CustomEditorKit.new)
    @styles = Hash.new
    @line_indice = Array.new
    @unsaved = false
    @style_in_progress = false
    
    # Document Styles
    @styles[:shared] = javax.swing.text.SimpleAttributeSet.new
    javax.swing.text.StyleConstants.setFontFamily(@styles[:shared], FONT_FAMILY);
    javax.swing.text.StyleConstants.setFontSize(@styles[:shared], FONT_SIZE); 
      
    @styles[:standard] = javax.swing.text.SimpleAttributeSet.new(@styles[:shared])
    javax.swing.text.StyleConstants.setForeground(@styles[:standard], java.awt.Color.black)
    
    @styles[:highlight] = javax.swing.text.SimpleAttributeSet.new(@styles[:shared])
    javax.swing.text.StyleConstants.setForeground(@styles[:highlight], java.awt.Color.red)
    javax.swing.text.StyleConstants.setBold(@styles[:highlight], true)
    
    @styles[:invalid] = javax.swing.text.SimpleAttributeSet.new(@styles[:shared])
    @styles[:invalid].addAttribute(ANNOTATION, "error")

    @styles[:warning] = javax.swing.text.SimpleAttributeSet.new(@styles[:shared])
    @styles[:warning].addAttribute(ANNOTATION, "warning")
    
    @styles[:symbol] = javax.swing.text.SimpleAttributeSet.new(@styles[:shared])
    javax.swing.text.StyleConstants.setForeground(@styles[:symbol], java.awt.Color.new(0, 64, 128))
    javax.swing.text.StyleConstants.setBold(@styles[:symbol], true)

    @styles[:lookup] = javax.swing.text.SimpleAttributeSet.new(@styles[:shared])
    javax.swing.text.StyleConstants.setForeground(@styles[:lookup], java.awt.Color.new(63, 127, 95))

    @styles[:literal] = javax.swing.text.SimpleAttributeSet.new(@styles[:shared])
    javax.swing.text.StyleConstants.setForeground(@styles[:literal], java.awt.Color.new(42, 0, 255))

    @styles[:regexp] = javax.swing.text.SimpleAttributeSet.new(@styles[:shared])
    javax.swing.text.StyleConstants.setForeground(@styles[:regexp], java.awt.Color.new(90, 30, 160))

    @styles[:comment] = javax.swing.text.SimpleAttributeSet.new(@styles[:shared])
    javax.swing.text.StyleConstants.setForeground(@styles[:comment], java.awt.Color.new(127, 159, 191))

    @styles[:stepthrough] = javax.swing.text.SimpleAttributeSet.new(@styles[:shared])
    javax.swing.text.StyleConstants.setBackground(@styles[:stepthrough], java.awt.Color.new(245, 213, 74))

    @styles[:breakpoint] = javax.swing.text.SimpleAttributeSet.new(@styles[:shared])
    javax.swing.text.StyleConstants.setForeground(@styles[:breakpoint], java.awt.Color.new(255, 255, 255))
    javax.swing.text.StyleConstants.setBackground(@styles[:breakpoint], java.awt.Color.new(151, 34, 39))
    
    @document = @editor.getStyledDocument
    reset_style
  end
  
  def focus_at_line(line_number)
    #puts line_number
    update_line_index
    @editor.setSelectionStart(@line_indice[line_number])
    @editor.setSelectionEnd(@line_indice[line_number+1])
    SwingUtils.invoke_block_later do
      @editor.scrollRectToVisible(java.awt.Rectangle.new(0, (line_number - 1) * FONT_SIZE, 1, 1))
      @editor.requestFocus
    end
  end
  
  def style(value)
    @editor.setUndoActive(!value)
    @style_in_progress = value
  end
  
  def style_in_progress
    @style_in_progress
  end
  
  def add_document_listener(object)
    @document.addDocumentListener(object)
  end
  
  def set_style(start_line, start_col, end_line, end_col, style = :highlight, reset = true)
    style(true)
    update_line_index
    
    start_pos = @line_indice[start_line] + start_col
    end_pos = @line_indice[end_line] + end_col
    
    @document.setCharacterAttributes(start_pos, end_pos - start_pos + 1, @styles[style], reset)
    style(false)
  end
  
  def reset_style
    self.style(true)
    @document.setCharacterAttributes(0, @document.getLength + 2, @styles[:standard], REPLACE_STYLE)
    self.style(false)
  end
  
  def text
    @document.getText(0, @document.getLength)
  end
  
  def text=(value)
    @editor.setText(value)
    @editor.resetUndo
    reset_style
  end
  
  def editable=(value)
    @editor.setEditable(value)
  end
  
  def editable
    @editor.getEditable
  end
  
  def unsaved?
    @unsaved
  end
  
  def update_line_index
    @line_indice.clear
    @line_indice.push(0)
    pos = 0
    self.text.each_line do |line|
      @line_indice.push pos
      pos += line.length
    end
    @line_indice.push(pos)
  end
  
end