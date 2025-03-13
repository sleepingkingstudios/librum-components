# frozen_string_literal: true

require 'librum/components/options'

module Librum::Components::Options
  # Option for passing a class name parameter to a component.
  module ClassName
    include Librum::Components::Options

    option :class_name, validate: true

    private

    def validate_class_name(value, as:) # rubocop:disable Metrics/CyclomaticComplexity
      return if value.nil?
      return if value.is_a?(String) || value.is_a?(Symbol)

      return if value.is_a?(Array) &&
                value.all? { |item| item.is_a?(String) || item.is_a?(Symbol) }

      "#{as} must be a String or Array of Strings"
    end
  end
end
