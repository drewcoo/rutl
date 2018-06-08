require 'rutl/element/element'
require 'rutl/element/string_reader_writer_mixin.rb'

module RUTL
  module Element
    #
    # I'm using the text element for all text-like things. Passowrds, too.
    # TODO: Also have a reader only class with StringReaderMixin for labels?
    #
    class Text < Element
      include StringReaderWriterMixin
    end
  end
end
