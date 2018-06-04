require 'rutl/interface/elements/base_element'
require 'rutl/interface/elements/string_reader_writer_mixin.rb'

#
# I'm using the text element for all text-like things. Passowrds, too.
# TODO: Also have a reader only class with StringReaderMixin for labels?
#
class Text < BaseElement
  include StringReaderWriterMixin
end
