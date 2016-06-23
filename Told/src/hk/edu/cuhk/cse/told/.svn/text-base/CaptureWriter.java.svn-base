package hk.edu.cuhk.cse.told;

import java.io.IOException;
import java.io.Writer;
import java.util.ArrayList;
import java.util.Iterator;

public class CaptureWriter extends Writer {
	
	private ArrayList<CaptureListener> listeners;
	private boolean warning; 
	
	public CaptureWriter(){
		this(false);
	}
	
	public CaptureWriter(boolean warning){
		super();
		this.warning = warning;
		listeners = new ArrayList<CaptureListener>();
	}
	
	public void setWarning(boolean value){
		warning = value;
	}

	@Override
	public void close() throws IOException {
	}

	@Override
	public void flush() throws IOException {
	}

	@Override
	public void write(char[] cbuf, int off, int len) throws IOException {
		Iterator<CaptureListener> itr = listeners.iterator();
	    while (itr.hasNext()) {
	      CaptureListener element = itr.next();
	      writeToListener(element, cbuf, off, len);
	    }
	}
	
	public void addCaptureListener(CaptureListener l){
		listeners.add(l);
	}
	
	public void removeCaptureListener(CaptureListener l){
		listeners.remove(l);
	}
	
	protected void writeToListener(CaptureListener l, char[] cbuf, int off, int len){
		l.contentCaptured(new String(cbuf, off, len), warning);
	}

}
