include Java

require 'grammar/grammar.rb'
require 'grammar/grammar_element.rb'
require 'grammar/grammar_group.rb'
require 'component/toggle_flat_button.rb'

class GrammarPane < javax.swing.JPanel
  include java.awt.event.ActionListener
  include javax.swing.event.DocumentListener
  
  attr_accessor :main_window
  attr_accessor :editor
  attr_accessor :tab_id
  attr_reader :icon
  attr_reader :title
  attr_reader :mode
  
  def initialize(main_window)
    super()
    @main_window = main_window
    @title = "Grammar"
    @icon = "code_red"
    @mode = :edit
    create_components
    @saved = false
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
  
  def mode=(value)
    if value == :edit
      @mode = :edit
      @buttons[:edit].button_pressed = true
      @editor.editable = true
      @editor.reset_style
    elsif value == :visualize
      @mode = :visualize
      @buttons[:visualize].button_pressed = true
      @editor.editable = false
      @main_window.grammar.source = @editor.text
    end
  end
  
  def update_dropdown(grammar)
    if grammar
      @dropdown.removeAllItems
      @dropdown_map = {}
      grammar.symbols.values.sort{|a,b|a.symbol<=>b.symbol}.each do |s|
        @dropdown_map[s.symbol.to_s] = s.line_number
        @dropdown.addItem(s.symbol.to_s)
      end
    end
  end
  
  def syntax_highlight(grammar)
    @editor.reset_style
    @editor.update_line_index
    
    grammar.comments.each do |line_number|
      @editor.set_style(line_number, 0, line_number + 1, -1, :comment, false)
    end
    
    grammar.symbols.each_value do |symbol|
      @editor.set_style(symbol.line_number, symbol.column_start, symbol.line_number, symbol.column_end, :symbol, false)
      symbol.expressions.each do |expr|
        if expr.kind_of?(GrammarGroup)
          expr.choices.each do |choice|
            if choice.kind_of?(GrammarElement)
              @editor.set_style(choice.line_number, choice.column_start, choice.line_number, choice.column_end, choice.type_name, false)
            end
          end
        elsif expr.kind_of?(GrammarElement)
          @editor.set_style(expr.line_number, expr.column_start, expr.line_number, expr.column_end, expr.type_name, false)
        else
          next
        end
      end
    end

    grammar.warnings.each do |warning|
      @editor.set_style(warning.content.line_number, warning.content.column_start, warning.content.line_number, warning.content.column_end, :warning, false)
    end

    grammar.errors.each do |err|
      @editor.set_style(err.content.line_number, err.content.column_start, err.content.line_number, err.content.column_end, :invalid, false)
    end

    update_dropdown(grammar)
  
  end
  
  def actionPerformed(e)
    if (e.getSource == @buttons[:visualize])
      self.mode = :visualize
    elsif (e.getSource == @buttons[:edit])
      self.mode = :edit
    elsif (e.getSource == @dropdown)
      symbol = @dropdown.getSelectedItem
      if symbol and @dropdown_map
        line_number = @dropdown_map[symbol]
        unless line_number.nil? 
          @editor.focus_at_line(line_number)
        end
      end
    end
  end

  def saved?
    @saved
  end
  
  def project_saved
    @saved = true
  end
  
  protected 
  def create_components
    self.setLayout(javax.swing.BoxLayout.new(self, javax.swing.BoxLayout::PAGE_AXIS))
    self.setMinimumSize(java.awt.Dimension.new(400, 300))
    
    @editor = Editor.new
    @editor.add_document_listener(self)
    @editor.setAlignmentX(java.awt.Component::RIGHT_ALIGNMENT)
    @toolbar = javax.swing.JPanel.new
    @toolbar.setLayout(javax.swing.BoxLayout.new(@toolbar, javax.swing.BoxLayout::X_AXIS))
    @toolbar.setAlignmentX(java.awt.Component::RIGHT_ALIGNMENT)
    
    @dropdown = javax.swing.JComboBox.new
    @dropdown.addActionListener(self)
    #@dropdown.setAlignmentX(java.awt.Component::LEFT_ALIGNMENT)
    @toolbar.add(@dropdown)
    
    # create buttons
    @buttons = Hash.new
    @buttons[:edit] = ToggleFlatButton.new("Edit")
    @buttons[:edit].setIcon($icon_library.getIcon("edit"))
    @buttons[:edit].button_pressed = true
    @buttons[:visualize] = ToggleFlatButton.new("Visualize")
    @buttons[:visualize].setIcon($icon_library.getIcon("visualize"))
    @buttons[:visualize].link(@buttons[:edit])
    @buttons[:edit].link(@buttons[:visualize])
    
    @buttons.each_value do |button|
      button.addActionListener(self)
      @toolbar.add(button)
    end
    self.add(@toolbar)
    self.add(@editor)
  end
  
  def changed
    unless @editor.style_in_progress
      @main_window.changed(self)
      @saved = false
    end
  end

end