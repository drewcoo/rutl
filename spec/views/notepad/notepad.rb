require 'rutl/view'

class Notepad < RUTL::View
  def layout
    text :edit, { xpath: '/Window/Edit' }
    # file_menu = { name: 'File' }
    # file_menu_new = { name: 'New' }
    # file_menu_open = { name: 'Open...' }
    # help_menu = { name: 'Help' }
    # help_menu_about = { name: 'About Notepad' }
    # about_dialog = { name: 'About Notepad' }
    # about_dialog_ok = { name: 'OK' }
    button :close, { name: 'Close' }, [Notepad]
    button :dialog_dont_save, { xpath: '/Window/Window/Button[2]' }, [Notepad]
  end

  def loaded?
    true
  end
end
