package hk.edu.cuhk.cse.told.component;

import java.io.File;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Hashtable;

import javax.swing.ImageIcon;

public class IconLibrary {
	
	public static String PREFIX = "images/";
	
	private Hashtable<String, ImageIcon> icons;
	
	public IconLibrary(){
		// initialize the icon library by adding the files
		icons = new Hashtable<String, ImageIcon>();
		
		// add icons
		addIcon("block", "block.png");
		addIcon("multi", "multi.png");
		addIcon("terminal", "terminal.png");
		addIcon("console", "console.png");
		addIcon("code_blue", "code_blue.png");
		addIcon("code_red", "code_red.png");
		addIcon("code_green", "code_green.png");
		addIcon("code_unused", "page_white_error.png");
		addIcon("settings", "cog.png");
		addIcon("edit", "pencil.png");
		addIcon("error", "exclamation.png");
		addIcon("star", "star.png");
		addIcon("lock", "lock.png");
		addIcon("table", "table.png");
		addIcon("tree", "ast.png");
		addIcon("token", "plugin_disabled.png");
		addIcon("tokens", "coins.png");
		addIcon("console_clear", "console_clear.png");
		addIcon("console_slock", "console_slock.png");
		addIcon("save", "disk.png");
		addIcon("save_all", "disk_multiple.png");
		addIcon("parse", "brick_go.png");
		addIcon("run", "control_play_blue.png");
		addIcon("stepthrough", "control_play.png");
		addIcon("continue", "control_fastforward.png");
		addIcon("stop", "control_stop.png");
		addIcon("visualize", "eye.png");
		addIcon("project", "book_open.png");
		addIcon("project_closed", "book.png");
		addIcon("folder_settings", "folder_wrench.png");
		addIcon("folder_semantics", "folder_brick.png");
		addIcon("folder_grammar", "folder_page_white.png");
		addIcon("folder_codes", "folder_edit.png");
		addIcon("grammar_generate", "page_refresh.png");
		addIcon("window_max", "application.png");
		addIcon("window_min", "application_put.png");
		addIcon("window_restore", "application_double.png");
	}
	
	protected void addIcon(String name, String path){
		// add a icon to the library
		URL url = this.getClass().getClassLoader().getResource(PREFIX + path);
		if (url == null){
			// no embedded resouce (debug mode?)
			// load from file system instead
			try {
				url = new File(PREFIX + path).toURL();
			} catch (MalformedURLException e) {
				// File not found
				e.printStackTrace();
			}
		}
		
		if (url != null)
			icons.put(name, new ImageIcon(url));
	}
	
	public ImageIcon getIcon(String name){
		return icons.get(name);
	}
	
}
