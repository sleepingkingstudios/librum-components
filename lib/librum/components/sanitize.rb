# frozen_string_literal: true

require 'loofah/helpers'

require 'librum/components'

module Librum::Components
  # Helper methods for sanitizing HTML tags and attributes.
  module Sanitize
    # Removes unsafe HTML tags and attributes.
    #
    # @param raw [String, nil] the value to sanitize.
    #
    # @return [String, nil] the sanitized value.
    def sanitize(raw)
      return if raw.nil?
      return '' if raw.empty?

      Loofah::Helpers.sanitize(raw).html_safe # rubocop:disable Rails/OutputSafety
    end

    # Removes all HTML tags and attributes.
    #
    # @param raw [String, nil] the value to sanitize.
    #
    # @return [String, nil] the sanitized value.
    def strip_tags(raw)
      return if raw.nil?
      return '' if raw.empty?

      Loofah::Helpers.strip_tags(raw).html_safe # rubocop:disable Rails/OutputSafety
    end
  end
end
