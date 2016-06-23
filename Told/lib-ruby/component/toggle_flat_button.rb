include Java

require 'component/flat_button.rb'

class ToggleFlatButton < FlatButton

  attr_accessor :normal_text, :pressed_text
  attr_reader :button_pressed
  
  def initialize(normal_text, pressed_text = nil)
    super(normal_text)
    @linked_buttons = []
    @button_pressed = false
    @normal_text = normal_text
    @pressed_text = pressed_text ? pressed_text : normal_text
  end
  
  def button_pressed=(value)
    @button_pressed = value
    setBorder(@button_pressed ? @@pressed : @@normal)
    setText(@button_pressed ? @pressed_text: @normal_text)
    
    # reset 
    if linked? and value
      @linked_buttons.each do |button|
        button.button_pressed = false
      end
    end
  end
  
  def mousePressed(e)
    if linked?
      if @button_pressed
        e.consume
      else
        self.button_pressed = true
      end
    else
      @button_pressed = ! @button_pressed
      setText(@button_pressed ? @pressed_text: @normal_text)
      setBorder(@button_pressed ? @@pressed : @@normal)
    end
  end
  
  def mouseExited(e)
    setBorder(@button_pressed ? @@pressed : @@normal)
  end
  
  def mouseEntered(e)
    unless @button_pressed
      setBorder(@@entered)
    end
  end
  
  def mouseReleased(e)

  end
  
  def link(button)
    @linked_buttons.push(button)
  end
  
  def unlink(button)
    @linked_buttons.delete(button)
  end
  
  protected
  def linked?
    @linked_buttons.length > 0
  end
  
end