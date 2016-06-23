include Java

import javax.swing.BorderFactory
import javax.swing.border.BevelBorder

# A Flat-styled button
class FlatButton < javax.swing.JButton
  include java.awt.event.MouseListener
  
  # Inner class responsible for drawing the border of the flat button
  class FlatBorder < javax.swing.border.AbstractBorder
    RAISED  = 0
    LOWERED = 1
  
    def initialize(bevel_type, highlight, shadow)
      super()
      @bevel_type = bevel_type
      @highlight = highlight
      @shadow = shadow
    end
    
    def paintBorder(component, graphics, x, y, width, height)
      case @bevel_type
        when RAISED
          paintRaisedBevel(component, graphics, x, y, width, height)
        when LOWERED
          paintLoweredBevel(component, graphics, x, y, width, height)
      end
    end
    
    def getBorderInsets(component, insets = nil)
      if insets
        insets.left = 1 
        insets.top = 1
        insets.right 1
        insets.bottom = 1
      end
      java.awt.Insets.new(1, 1, 1, 1)
    end
      
    def getHighlightColor(component)
      @highlight ? @highlight : component.getBackground.brighter
    end
    
    def getShadowColor(component)
      @shadow ? @shadow : component.getBackground.darker    
    end
  
    def getBevelType
      @bevel_type
    end
    
    def isBorderOpaque
      true
    end
    
    protected
    
    def paintRaisedBevel(component, graphics, x, y, width, height)
      old_color = graphics.getColor
      
      graphics.translate(x, y)
   
      # draw highlight
      graphics.setColor(getHighlightColor(component))
      graphics.drawLine(0, 0, 0, height -2)
      graphics.drawLine(0, 0, width - 2, 0)
   
      # draw shadow
      graphics.setColor(getShadowColor(component))
      graphics.drawLine(0, height - 1, width - 1, height - 1)
      graphics.drawLine(width - 1, 0, width - 1, height - 2)
   
      graphics.translate(-x, -y)
      graphics.setColor(old_color)
    end
    
    def paintLoweredBevel(component, graphics, x, y, width, height)
      old_color = graphics.getColor
      
      graphics.translate(x, y)
   
      # draw shadow
      graphics.setColor(getShadowColor(component))
      graphics.drawLine(0, 0, 0, height - 1)
      graphics.drawLine(1, 0, width - 1, 0)
      
      # draw highlight
      graphics.setColor(getHighlightColor(component))
      graphics.drawLine(1, height - 1, width - 1, height -1)
      graphics.drawLine(width - 1, 1, width - 1, height - 2)
   
      graphics.translate(-x, -y)
      graphics.setColor(old_color)
    end
    
  end


  @@margin = BorderFactory.createEmptyBorder(2, 2, 2, 2);
  @@empty = BorderFactory.createEmptyBorder(1, 1, 1, 1);
  @@raised = FlatBorder.new(FlatBorder::RAISED, nil, nil)
  @@lowered = FlatBorder.new(FlatBorder::LOWERED, nil, nil)
  @@normal = BorderFactory.createCompoundBorder(@@empty, @@margin)
  @@entered = BorderFactory.createCompoundBorder(@@raised, @@margin)
  @@pressed = BorderFactory.createCompoundBorder(@@lowered, @@margin)

  def initialize(text)
    super()
    setText(text)
    setBorder(@@normal)
    setBackground(nil)
    setContentAreaFilled(false)
    setFocusPainted(false)
    addMouseListener(self)
  end
  
  def mouseClicked(e)
    
  end
  
  def mouseEntered(e)
    setBorder(@@entered)    
  end
  
  def mouseExited(e)
    setBorder(@@normal)
  end
  
  def mousePressed(e)
    setBorder(@@pressed)
  end
  
  def mouseReleased(e)
    if getBorder == @@pressed
      setBorder(@@entered)
    end
  end
end

