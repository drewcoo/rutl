require 'rutl/interface/elements/element'
require 'rutl/interface/elements/string_reader_writer_mixin.rb'

module RUTL
  #
  # I'm using the text element for all text-like things. Passowrds, too.
  # TODO: Also have a reader only class with StringReaderMixin for labels?
  #
  class Text < Element
    include StringReaderWriterMixin
  end
end
