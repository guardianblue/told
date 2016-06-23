include Java

import javax.swing.ImageIcon

class IconLibrary
  
  attr_accessor :base_path, :icons
  
  def initialize(base_path)
    @base_path = base_path
    @icons = {
      :block => ImageIcon.new(base_path + "images/block.png"),
      :multi => ImageIcon.new(base_path + "images/multi.png"),
      :terminal => ImageIcon.new(base_path + "images/terminal.png"),
      :ast => ImageIcon.new(base_path + "images/ast.png"),
      :console => ImageIcon.new(base_path + "images/console.png"),
      :code_blue => ImageIcon.new(base_path + "images/code_blue.png"),
      :code_red => ImageIcon.new(base_path + "images/code_red.png"),
      :code_green => ImageIcon.new(base_path + "images/code_green.png"),
      :cog => ImageIcon.new(base_path + "images/cog.png"),
      :error => ImageIcon.new(base_path + "images/exclamation.png"),
      :star => ImageIcon.new(base_path + "images/star.png"),
      :lock => ImageIcon.new(base_path + "images/lock.png"),
      :table => ImageIcon.new(base_path + "images/table.png"),
      :console_clear => ImageIcon.new(base_path + "images/console_clear.png"),
      :console_slock => ImageIcon.new(base_path + "images/console_slock.png"),
      :step_through => ImageIcon.new(base_path + "images/control_play_blue.png"),
      :project => ImageIcon.new(base_path + "images/book_open.png"),
      :project_closed => ImageIcon.new(base_path + "images/book.png"),
      :folder_settings => ImageIcon.new(base_path + "images/folder_wrench.png"),
      :folder_semantics => ImageIcon.new(base_path + "images/folder_brick.png"),
      :folder_grammar => ImageIcon.new(base_path + "images/folder_page_white.png"),
      :folder_codes => ImageIcon.new(base_path + "images/folder_edit.png"),
      :grammar_generate => ImageIcon.new(base_path + "images/page_refresh.png")
    }
  end
  
end