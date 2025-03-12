# frozen_string_literal: true

require 'librum/components'

module Librum::Components
  # Component wrapping a sanitized HTML string.
  class Literal < Librum::Components::Base
    # @param contents [String] the HTML string to render.
    def initialize(contents)
      super()

      @contents = contents
    end

    # @return [String] the HTML string to render.
    attr_reader :contents

    # Scrubs the contents and wraps in an HTML-safe buffer.
    #
    # @return [ActiveSupport::SafeBuffer] the scrubbed component contents.
    def call
      Loofah
        .html5_fragment(contents)
        .scrub!(:strip)
        .to_s
        .html_safe # rubocop:disable Rails/OutputSafety
    end
  end
end
