# frozen_string_literal: true

require 'rails'
require 'view_component'

module Librum::Components::Options
  # Default helper methods for validating option values.
  module ValidationHelpers
    private

    def validate_color(value, as: 'color')
      return if value.nil?
      return if configuration.colors.include?(value)

      "#{as} is not a valid color name"
    end

    def validate_component(value, as: 'value')
      return if value.nil?
      return if value.is_a?(Hash)
      return if value.is_a?(::ViewComponent::Base)

      "#{as} is not a component or options Hash"
    end

    def validate_icon(value, as: 'icon')
      return if value.nil?
      return if value.is_a?(String)
      return if value.is_a?(Hash) && value.key?(:icon)
      return if value.is_a?(::ViewComponent::Base)

      "#{as} is not a valid icon"
    end

    def validate_inclusion(value, expected:, as: 'value')
      return if value.nil?
      return if expected.include?(value)

      "#{as} is not included in the list"
    end

    def validate_size(value, as: 'size')
      return if value.nil?
      return if configuration.sizes.include?(value)

      "#{as} is not a valid size"
    end
  end
end
