require 'rutl/view'

class Hello < RUTL::View
  def layout
    button :close, { name: 'Close' }, [Hello]
    button :exit, { xpath: '/Window/Pane/Button' }, [Hello]
  end

  def loaded?
    true
  end
end
