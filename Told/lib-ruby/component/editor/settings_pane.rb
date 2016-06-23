include Java

require 'component/flat_button.rb'

include_class 'hk.edu.cuhk.cse.told.component.layout.SpringUtilities'

class SettingsPane < javax.swing.JPanel
  include java.awt.event.ActionListener
  include javax.swing.event.DocumentListener
  
  attr_accessor :main_window
  attr_accessor :tab_id
  attr_reader :icon
  attr_reader :title
  
  def initialize(main_window)
    super()
    @main_window = main_window
    @title = "Settings"
    @icon = "settings"
    @properties = ["Project Name", "Author", "Description", "Symbol Table Type", "Tokenize Space Manually"] 
    @property_tags = ["project_name", "author", "description", "symbol_table_type", "manual_space"]
    @property_types = [:text, :text, :textarea, ["Lexical", "Dynamic"], ["No", "Yes"]]
    @property_components = Hash.new
    @property_values = Hash.new
    @saved = true
    create_components
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
  
  # Mouse action
  def actionPerformed(e)
    if e.getSource == @buttons[:save]
      @main_window.update_settings
    else
      # any of the properties have been changed
      changed      
    end
  end
  
  def property_values=(properties)
    properties.each_pair do |tag, value|
      index = @property_tags.index(tag)
      if index
        component = @property_components[@properties[index]]
        prop_type = @property_types[index]
        if prop_type.kind_of?(Array)
          if (value.to_i < 0 or value.to_i > prop_type.length)
            value = 0
          end
          component.setSelectedIndex(value.to_i)
        elsif prop_type == :text
          component.setText(value)
        elsif prop_type == :textarea
          component.setText(value)
        end
      end
    end
  end
  
  # Fetch the values from the control, and return as a hash
  def property_values
    @property_values.clear
    @properties.each_with_index do |prop, i|
      prop_type = @property_types[i]
      value = if prop_type.kind_of?(Array)
                @property_components[prop].getSelectedIndex
              elsif prop_type == :text
                @property_components[prop].getText
              elsif prop_type == :textarea
                @property_components[prop].getText
              end
      @property_values[@property_tags[i]] = value
    end
    @property_values
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
    
    @toolbar = javax.swing.JPanel.new
    @toolbar.setLayout(javax.swing.BoxLayout.new(@toolbar, javax.swing.BoxLayout::X_AXIS))
    @toolbar.setAlignmentX(java.awt.Component::RIGHT_ALIGNMENT)
    
    @buttons = Hash.new
    @buttons[:save] = FlatButton.new("Update Settings")
    @buttons[:save].setIcon($icon_library.getIcon("save"))
    
    @buttons.each_value do |button|
      button.addActionListener(self)
      @toolbar.add(button)
    end
    
    @content_pane = javax.swing.JPanel.new(javax.swing.SpringLayout.new)
    @content_pane.setAlignmentX(java.awt.Component::RIGHT_ALIGNMENT)
    
    @properties.each_with_index do |prop, i|
      label = javax.swing.JLabel.new(prop, javax.swing.JLabel::TRAILING)
      @content_pane.add(label)
      prop_type = @property_types[i]
      component = if prop_type.kind_of?(Array)
                    combo = javax.swing.JComboBox.new()
                    prop_type.each do |item|
                      combo.addItem(item)
                    end
                    combo
                  elsif prop_type == :text
                    javax.swing.JTextField.new(80)
                  elsif prop_type == :textarea
                    javax.swing.JTextArea.new()
                  end
                  
      # prevent components other than text area from strecting
      if prop_type != :textarea
        component.setMaximumSize(java.awt.Dimension.new(java.lang.Integer::MAX_VALUE, component.getMinimumSize.height))
      end

      @property_components[prop] = component          
      label.setLabelFor(component)
      if prop_type == :textarea
        component.getDocument.addDocumentListener(self)
        @content_pane.add(javax.swing.JScrollPane.new(component))
      else
        component.addActionListener(self)
        @content_pane.add(component)
      end
      
    end
    SpringUtilities.makeCompactGrid(@content_pane, @properties.length, 2, 6, 6, 6, 6)
        
    self.add(@toolbar)
    self.add(@content_pane)
    
  end
  
  def changed
    @main_window.changed(self)
  end
  
end