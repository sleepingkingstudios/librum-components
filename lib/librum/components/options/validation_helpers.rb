# frozen_string_literal: true

require 'rails'
require 'view_component'

module Librum::Components::Options
  # Default helper methods for validating option values.
  module ValidationHelpers
    # The valid options for the :http_method option.
    HTTP_METHODS = Set.new(%w[delete get head patch post put]).freeze

    private

    def error_message_for(error, as: nil, **)
      error = "sleeping_king_studios.tools.assertions.#{error}"

      SleepingKingStudios::Tools::Toolbelt
        .instance
        .assertions
        .error_message_for(error, as:, **)
    end

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

    def validate_http_method(value, as: 'http_method')
      return if value.nil?

      unless value.is_a?(String) || value.is_a?(Symbol)
        return error_message_for('name', as:)
      end

      normalized = value.to_s.underscore.strip

      return error_message_for('presence', as:) if value.empty?

      return if HTTP_METHODS.include?(normalized)

      "#{as} is not a valid http method - valid values are " \
        "#{HTTP_METHODS.map(&:upcase).join(', ')}"
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
