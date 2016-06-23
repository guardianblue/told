package hk.edu.cuhk.cse.told.component;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.Shape;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.KeyEvent;

import javax.swing.AbstractAction;
import javax.swing.Action;
import javax.swing.JComponent;
import javax.swing.JTextPane;
import javax.swing.KeyStroke;
import javax.swing.event.UndoableEditEvent;
import javax.swing.text.AbstractDocument;
import javax.swing.text.BoxView;
import javax.swing.text.ComponentView;
import javax.swing.text.Element;
import javax.swing.text.IconView;
import javax.swing.text.LabelView;
import javax.swing.text.ParagraphView;
import javax.swing.text.StyleConstants;
import javax.swing.text.StyledEditorKit;
import javax.swing.text.View;
import javax.swing.text.ViewFactory;
import javax.swing.undo.CannotRedoException;
import javax.swing.undo.CannotUndoException;
import javax.swing.undo.UndoManager;

// This class is declared in Java space as JRuby is problematic in overriding Java object
public class SyntaxHighlightEditor extends JTextPane {
	
	public static String ANNOTATION = "annotation";
	private LineNumberPanel lineNumberPanel;
	private PausableUndoManager undoManager;
	
	public class SyntaxHighlightEditorKit extends StyledEditorKit {
		
		public SyntaxHighlightEditorKit(){
			super();
		}
		
		public ViewFactory getViewFactory(){
			return new SyntaxHighlightViewFactory();
		}
		
	}
		
	public class SyntaxHighlightViewFactory implements ViewFactory {
		
		public View create(Element elem){
			String kind = elem.getName();
			if (kind != null){
				if (kind.equals(AbstractDocument.ContentElementName)){
					return new SyntaxHighlightLabelView(elem);
				}else if (kind.equals(AbstractDocument.ParagraphElementName)){
					return new NoWrapParagraphView(elem);
				}else if (kind.equals(AbstractDocument.SectionElementName)){
					return new BoxView(elem, View.Y_AXIS);
				}else if (kind.equals(StyleConstants.ComponentElementName)){
					return new ComponentView(elem);
				}else if (kind.equals(StyleConstants.IconElementName)){
					return new IconView(elem);
				}
			}
			return new LabelView(elem);
		}
		
	}
	
	public class NoWrapParagraphView extends ParagraphView {
	    public NoWrapParagraphView(Element elem) {
	        super(elem);
	    }

	    public void layout(int width, int height) {
	        super.layout(Short.MAX_VALUE, height);
	    }

	    public float getMinimumSpan(int axis) {
	        return super.getPreferredSpan(axis);
	    }
	}
	
	public class SyntaxHighlightLabelView extends LabelView {
		
		public final Color COLOR_WARNING = new Color(255, 201, 0);
		public final Color COLOR_ERROR = new Color(255, 0, 129);
		
		public SyntaxHighlightLabelView(Element elem){
			super(elem);
		}
		
		public void paint(Graphics g, Shape allocation){
			super.paint(g, allocation);
			String annotation = (String) getElement().getAttributes().getAttribute(ANNOTATION);
			if (annotation != null){
				if (annotation.equals("error")){
					paintZigzag(g, allocation, COLOR_ERROR);
				}else if (annotation.equals("warning")){
					paintZigzag(g, allocation, COLOR_WARNING);
				}
			}
			if (lineNumberPanel != null){
				lineNumberPanel.repaint();
			}
		}
		
		private void paintZigzag(Graphics g, Shape allocation, Color color){
			
			// Calculate boundaries
			int y = (int) (allocation.getBounds().getY() + allocation.getBounds().getHeight() - 1);
			int x1 = (int) allocation.getBounds().getX();
			int x2 = (int) (allocation.getBounds().getX() + allocation.getBounds().getWidth());
			int w = 2;
			int h = 2;
 
			// preserve the color of the graphics object
			Color old = g.getColor();
			g.setColor(color);
			
			for (int i = x1; i < x2; i += w * 2){
				g.drawLine(i, y-h, i+w, y);
				g.drawLine(i+w, y, i+w*2, y-h);
			}
			
			// recover the color
			g.setColor(old);
 
		}
		
	}
	
	// The Undo action
	public class UndoAction extends AbstractAction {
		private UndoManager manager;

		public UndoAction(UndoManager manager) {
			this.manager = manager;
		}

    	public void actionPerformed(ActionEvent evt) {
    		try {
    			manager.undo();
    		} catch (CannotUndoException e) {
    			Toolkit.getDefaultToolkit().beep();
    		}
    	}

  	}

	// The Redo action
	public class RedoAction extends AbstractAction {
		private UndoManager manager;

		public RedoAction(UndoManager manager) {
			this.manager = manager;
		}

		public void actionPerformed(ActionEvent evt) {
			try {
				manager.redo();
			} catch (CannotRedoException e) {
				Toolkit.getDefaultToolkit().beep();
			}
		}

	}
	
	public class PausableUndoManager extends UndoManager{
		
		private boolean active;
		
		public PausableUndoManager(){
			super();
			active = true;
		}
		
		public void setActive(boolean value){
			active = value;
		}
		
		// @overrides
		public void undoableEditHappened(UndoableEditEvent e) {
			if (active){
				super.undoableEditHappened(e);
			}
		}
		
	}
	  
	public SyntaxHighlightEditor(){
		super();
		setEditorKit(new SyntaxHighlightEditorKit());
		undoManager = new PausableUndoManager();
	    getDocument().addUndoableEditListener(undoManager);

	    Action undoAction = new UndoAction(undoManager);
	    Action redoAction = new RedoAction(undoManager);
	    
	    registerKeyboardAction(undoAction, KeyStroke.getKeyStroke(KeyEvent.VK_Z, Toolkit.getDefaultToolkit().getMenuShortcutKeyMask()), JComponent.WHEN_FOCUSED);
        registerKeyboardAction(redoAction, KeyStroke.getKeyStroke(KeyEvent.VK_Y, Toolkit.getDefaultToolkit().getMenuShortcutKeyMask()), JComponent.WHEN_FOCUSED);
        
	}
	
	public void setLineNumberPanel(LineNumberPanel panel){
		lineNumberPanel = panel;
	}
	
	public void setUndoActive(boolean value){
		undoManager.setActive(value);
	}
	
	public void resetUndo(){
		undoManager.discardAllEdits();
	}
}