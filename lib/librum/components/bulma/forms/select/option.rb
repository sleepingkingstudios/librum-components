# frozen_string_literal: true

require 'librum/components'

module Librum::Components::Bulma::Forms
  # Renders a form select option.
  class Select::Option < Librum::Components::Bulma::Base
    PERMITTED_KEYS = Set.new(%i[label value disabled selected]).freeze
    private_constant :PERMITTED_KEYS

    class << self
      # Validates a value as an option definition.
      #
      # @param value [Object] the value to validate.
      # @param as [String] the name of the value to validate. Defaults to
      #   "option".
      #
      # @return [String, nil] the error message, or nil if the value is a
      #   valid option.
      def validate_option(value, as: 'option')
        invalid_type_error(value, as:) ||
          missing_keys_error(value, as:) ||
          extra_keys_error(value, as:)
      end

      private

      def extra_keys_error(value, as:)
        extra_keys = value.keys.reject { |key| PERMITTED_KEYS.include?(key) }

        return if extra_keys.empty?

        "#{as} has unknown propert#{extra_keys.size == 1 ? 'y' : 'ies'} " \
          "#{extra_keys.map(&:inspect).join(', ')}"
      end

      def invalid_type_error(value, as:)
        return if value.is_a?(Hash)

        SleepingKingStudios::Tools::Toolbelt
          .instance
          .assertions
          .error_message_for(
            'sleeping_king_studios.tools.assertions.instance_of',
            as:,
            expected: Hash
          )
      end

      def missing_keys_error(value, as:)
        return if value.key?(:label)

        "#{as} is missing required property :label"
      end
    end

    option :disabled, boolean:  true
    option :label,    required: true, validate: :name
    option :selected, boolean:  true
    option :value,    validate: String

    # Generates the form option.
    #
    # @return [ActiveSupport::SafeBuffer] the presented data.
    def call
      content_tag('option', **option_attributes) { label }
    end

    private

    def option_attributes
      {
        value:,
        disabled: disabled?,
        selected: selected?
      }.compact
    end
  end
end
