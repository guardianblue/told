include Java
# Component classes
require 'util/debug_manager.rb'
require 'component/main_window.rb'
include_class "hk.edu.cuhk.cse.told.component.IconLibrary"

# Define Java GUI

# Icon Library
$icon_library = IconLibrary.new

# Main window
main_window = MainWindow.new
main_window.setVisible(true)
