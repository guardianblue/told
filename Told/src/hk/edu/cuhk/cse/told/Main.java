package hk.edu.cuhk.cse.told;

import javax.swing.UIManager;

import org.jruby.embed.PathType;
import org.jruby.embed.ScriptingContainer;

public class Main {
		
	public static void main(String[] args) {

    	//Use native look and feel if available
		try {
		  UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
		} catch (Exception lafException) {
			System.err.println("Error setting native look and feel. Using default LAF");
		}
    		
		//Schedule a job for the event-dispatching thread:
        //creating and showing this application's GUI.
        javax.swing.SwingUtilities.invokeLater(new Runnable() {
            public void run() {
                initRubyEngine();
            }
        });
		
	}
	
	private static void initRubyEngine(){
		ScriptingContainer container = new ScriptingContainer();
		
		// capture STDOUT and STDERR
		CaptureWriter outCapture = new CaptureWriter();
		CaptureWriter errCapture = new CaptureWriter(true);
		container.setWriter(outCapture);
		container.setErrorWriter(errCapture);
		
		container.put("$out_capture", outCapture);
		container.put("$err_capture", errCapture);
		
		container.runScriptlet(PathType.CLASSPATH, "main.rb");
	}

}
