include Java

require 'component/flat_button.rb'
require 'component/console/console_view.rb'

class ConsolePane < javax.swing.JPanel
  include java.awt.event.ActionListener
  include java.awt.event.KeyListener
  
  # reference to main window
  attr_accessor :main_window
  attr_accessor :tab_id
  attr_reader :icon
  attr_reader :title
  # sub components
  attr_accessor :buttons
  attr_accessor :console_view
  
  def initialize(main_window)
    super()
    @main_window = main_window
    @icon = "console"
    @title = "Console"
    create_components
  end
  
  def keyReleased(e)
    
  end
  
  def keyTyped(e)
    
  end
  
  def keyPressed(e)
    if e.getKeyCode == java.awt.event.KeyEvent::VK_ENTER
      value =  @input_field.getText
      @console_view.append_input_text("#{value}\n")
      @input_field.setText("")
      standby_mode
      @main_window.runtime.provide_input(value)
    end
  end
  
  # Mouse Action Handling
  def actionPerformed(e)
    if e.getSource == @buttons[:clear]
      clear
    elsif e.getSource == @buttons[:lock]
      @console_view.scroll_lock = @buttons[:lock].button_pressed
    end
  end
  
  def clear
    @console_view.setText("")
  end
  
  def input_mode
    @input_field.setEnabled(true)
    @input_field.requestFocus
  end
  
  def standby_mode
    @input_field.setEnabled(false)
  end
  
  protected
  def create_components
    # layout manager for this component
    self.setLayout(javax.swing.BoxLayout.new(self, javax.swing.BoxLayout::PAGE_AXIS))
    
    # tool bar
    @toolbar = javax.swing.JPanel.new
    @toolbar.setLayout(javax.swing.BoxLayout.new(@toolbar, javax.swing.BoxLayout::X_AXIS))
    @toolbar.setAlignmentX(java.awt.Component::RIGHT_ALIGNMENT)
    
    @buttons = Hash.new
    @buttons[:clear] = FlatButton.new("Clear Console")
    @buttons[:clear].setIcon $icon_library.getIcon("console_clear")

    @buttons[:lock] = ToggleFlatButton.new("Scroll Lock")
    @buttons[:lock].setIcon $icon_library.getIcon("console_slock")
    @buttons[:lock].button_pressed = false

    @toolbar.add(@buttons[:clear])
    @toolbar.add(@buttons[:lock])

    @console_view = ConsoleView.new
    @console_view.setPreferredSize(java.awt.Dimension.new(400, 140))
    @console_view.setEditable false
    @scrollpane = javax.swing.JScrollPane.new(@console_view, 
                                                  javax.swing.JScrollPane::VERTICAL_SCROLLBAR_ALWAYS, 
                                                  javax.swing.JScrollPane::HORIZONTAL_SCROLLBAR_ALWAYS)
    @scrollpane.setAlignmentX(java.awt.Component::RIGHT_ALIGNMENT)
    @input_field = javax.swing.JTextField.new
    @input_field.setEnabled(false)
    @input_field.setFont(@console_view.font)
    @input_field.setMaximumSize(java.awt.Dimension.new(java.lang.Integer::MAX_VALUE, @input_field.getMinimumSize.height))
    @input_field.setAlignmentX(java.awt.Component::RIGHT_ALIGNMENT)
    
    # Standard/Error Output Capture
    $out_capture.addCaptureListener(console_view)
    $err_capture.addCaptureListener(console_view)
        
    # add action listener
    @buttons.each_value do |button|
      button.addActionListener(self)
    end
    @input_field.addKeyListener(self)
    
    self.add(@toolbar)
    self.add(@scrollpane)
    self.add(@input_field)

  end
end