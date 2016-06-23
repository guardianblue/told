include Java

require 'component/flat_button.rb'
require 'component/toggle_flat_button.rb'
require 'component/editor/editor.rb'

class CodePane < javax.swing.JPanel
  include java.awt.event.ActionListener
  include javax.swing.event.DocumentListener
  
  attr_accessor :main_window
  attr_accessor :editor
  attr_accessor :tab_id
  attr_reader :icon
  attr_reader :title
  
  def initialize(main_window)
    super()
    @main_window = main_window
    @title = "Sample code"
    @icon = "code_blue"
    @saved = true
    create_components   
  end
  
  def enter_run_mode
    editor.editable = false
    @buttons[:run].setEnabled(false)
    @buttons[:parse].setEnabled(false)
    @buttons[:step].setEnabled(false)
    @buttons[:continue].setEnabled(false)
    @buttons[:stop].setEnabled(true)
  end
  
  def enter_stepthrough_mode
    editor.editable = false
    @buttons[:run].setEnabled(false)
    @buttons[:parse].setEnabled(false)
    @buttons[:step].setEnabled(false)
    @buttons[:continue].setEnabled(false)
    @buttons[:stop].setEnabled(true)
  end
  
  def standby_mode
    editor.reset_style
    standby_mode!
  end
  
  def standby_mode!
    editor.editable = true
    @buttons[:run].setEnabled(true)
    @buttons[:parse].setEnabled(true)
    @buttons[:step].setEnabled(false)
    @buttons[:continue].setEnabled(false)
    @buttons[:stop].setEnabled(false)
  end
  
  
  def step_start
    @buttons[:step].setEnabled(false)
    @buttons[:continue].setEnabled(false)
  end

  def step_finish
    @buttons[:step].setEnabled(true)
    @buttons[:continue].setEnabled(true)
  end
  
  def actionPerformed(e)
    source = e.getSource
    if source == @buttons[:run]
      enter_run_mode
      @main_window.run_code(self, false)
    elsif source == @buttons[:parse]
      enter_stepthrough_mode
      @main_window.run_code(self, true)
    elsif source == @buttons[:step]
      step_start
      @main_window.stepthrough(self)
    elsif source == @buttons[:continue]
      enter_run_mode
      @main_window.run_continue(self)
    elsif source == @buttons[:stop]
      @main_window.stop_code
    end
  end
  
  def changedUpdate(e)
    changed
  end
  
  def insertUpdate(e)
    changed
  end
  
  def removeUpdate(e)
    changed
  end
  
  def saved?
    @saved
  end
  
  def project_saved
    @saved = true
  end
  
  protected
  def changed
    unless @editor.style_in_progress
      @saved = false
      @main_window.changed(self)
    end
  end
  
  def create_components
    self.setLayout(javax.swing.BoxLayout.new(self, javax.swing.BoxLayout::PAGE_AXIS))
    
    @editor = Editor.new
    @editor.add_document_listener(self)
    @editor.setAlignmentX(java.awt.Component::RIGHT_ALIGNMENT)
    @toolbar = javax.swing.JPanel.new
    @toolbar.setLayout(javax.swing.BoxLayout.new(@toolbar, javax.swing.BoxLayout::X_AXIS))
    
    @buttons = Hash.new
    @buttons[:run] = FlatButton.new("Run")
    @buttons[:run].setIcon $icon_library.getIcon("run")
    @buttons[:parse] = FlatButton.new("Parse")
    @buttons[:parse].setIcon $icon_library.getIcon("parse")
    @buttons[:step] = FlatButton.new("Stepthrough")
    @buttons[:step].setIcon $icon_library.getIcon("stepthrough")
    @buttons[:step].setEnabled(false)
    @buttons[:continue] = FlatButton.new("Continue")
    @buttons[:continue].setIcon $icon_library.getIcon("continue")
    @buttons[:continue].setEnabled(false)
    @buttons[:stop] = FlatButton.new("Stop")
    @buttons[:stop].setIcon $icon_library.getIcon("stop")
    @buttons[:stop].setEnabled(false)
    @toolbar.setAlignmentX(java.awt.Component::RIGHT_ALIGNMENT)
    
    # add action listener
    @buttons.each_value do |button|
      button.addActionListener(self)
      @toolbar.add(button)
    end
    
#    @toolbar.add(code_stepthrough)
    self.add(@toolbar)
    self.add(@editor)
  end
  
end