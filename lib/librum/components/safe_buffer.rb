# frozen_string_literal: true

require 'active_support'

require 'librum/components'

module Librum::Components
  # Helper methods for managing render-safe string buffers.
  module SafeBuffer
    # @overload safe_buffer()
    #   Generates a safe buffer for combining HTML-safe strings.
    #
    #   @return [ActiveSupport::SafeBuffer] the generated buffer.
    #
    # @overload safe_buffer(&block)
    #   Provides a safe buffer for combining HTML-safe strings.
    #
    #   @yieldparam [ActiveSupport::SafeBuffer] the generated buffer.
    def safe_buffer(&)
      buffer = ActiveSupport::SafeBuffer.new

      return buffer unless block_given?

      yield(buffer)

      buffer
    end

    # Checks if the value is a HTML-safe string.
    #
    # @param value [Object] the object to check.
    #
    # @return [true, false] true if the value is an HTML-safe string buffer,
    #   otherwise false.
    def safe_buffer?(value)
      value.is_a?(ActiveSupport::SafeBuffer)
    end

    # Strips leading and trailing whitespace from an HTML-safe buffer.
    #
    # @param buffer [ActiveSupport::SafeBuffer] the buffer to modify.
    #
    # @return [ActiveSupport::SafeBuffer] the trimmed buffer.
    def strip_buffer(buffer)
      SleepingKingStudios::Tools::Toolbelt
        .instance
        .assertions
        .validate_instance_of(buffer, expected: String)

      leading_count  = /\A\s+/.match(buffer)&.[](0)&.size
      trailing_count = /\s+\z/.match(buffer)&.[](0)&.size

      buffer[leading_count...(trailing_count&.then(&:-@))]
    end
  end
end
