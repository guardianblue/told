package hk.edu.cuhk.cse.told.component;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Point;

import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextPane;
import javax.swing.text.BadLocationException;
import javax.swing.text.Document;

public class LineNumberPanel extends JPanel {

	// for this simple experiment, we keep the pane + scrollpane as members.
	private JTextPane pane;
	private JScrollPane scrollPane;
	private Color lineColor;
	private Color numberColor;

	public LineNumberPanel(JTextPane textPane, JScrollPane scrollPane){
		super();
		this.pane = textPane;
		this.scrollPane = scrollPane;
		setBackground(scrollPane.getBackground());
		setMinimumSize(new Dimension(30, 30));
		setPreferredSize(new Dimension(30, 30));
		setMinimumSize(new Dimension(30, 30));
		setFont(pane.getFont());
		lineColor = Color.gray;
		numberColor = Color.darkGray;
	}

	public void paint(Graphics g){
		super.paint(g);
		Color old = g.getColor();
		
		g.setColor(numberColor);
		
		// Calculate positions
		int start = pane.viewToModel(scrollPane.getViewport().getViewPosition()); //starting pos in document
		int end = pane.viewToModel(new Point(scrollPane.getViewport().getViewPosition().x + pane.getWidth(),
											 scrollPane.getViewport().getViewPosition().y + pane.getHeight()));
				
		// translate offsets to lines
		Document doc = pane.getDocument();
		int startline = doc.getDefaultRootElement().getElementIndex(start) + 1;
		int endline = doc.getDefaultRootElement().getElementIndex(end) + 1;

		int fontHeight = g.getFontMetrics(pane.getFont()).getHeight();
		int fontDesc = g.getFontMetrics(pane.getFont()).getDescent();
		int starting_y = -1;

		try{
			starting_y = pane.modelToView(start).y - scrollPane.getViewport().getViewPosition().y + fontHeight - fontDesc;
		}catch (BadLocationException e){
			e.printStackTrace();
		}

		for (int line = startline, y = starting_y; line <= endline; y += fontHeight, line++){
			if (y < this.getHeight() - scrollPane.getHorizontalScrollBar().getHeight())
				g.drawString(Integer.toString(line), 0, y + 1);
		}
		g.setColor(lineColor);
		g.drawLine(this.getWidth() - 2, 0, this.getWidth() - 2, this.getHeight());
		g.setColor(old);
	}
}