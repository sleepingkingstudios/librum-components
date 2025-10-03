# frozen_string_literal: true

module Librum::Components::Bulma::Forms
  # Renders a form select option group.
  class SelectOptionGroup < Librum::Components::Bulma::Base
    EXPECTED_KEYS = Set.new(%i[label items]).freeze
    private_constant :EXPECTED_KEYS

    class << self
      # Validates a value as an option group definition.
      #
      # @param value [Object] the value to validate.
      # @param as [String] the name of the value to validate. Defaults to
      #   "option".
      #
      # @return [String, nil] the error message, or nil if the value is a
      #   valid options group.
      def validate_option_group(value, as: 'option group')
        invalid_group_type_error(value, as:) ||
          missing_keys_error(value, as:) ||
          extra_keys_error(value, as:) ||
          validate_options(value[:items], as:)
      end

      # Validates a value as a list of option definitions.
      #
      # @param value [Object] the value to validate.
      # @param as [String] the name of the value to validate. Defaults to
      #   "options".
      #
      # @return [String, nil] the error message, or nil if the value is a
      #   valid options list.
      def validate_options(value, as: 'options')
        invalid_type_error(value, as:) || invalid_items_error(value, as:)
      end

      private

      def extra_keys_error(value, as:)
        extra_keys = value.keys.reject { |key| EXPECTED_KEYS.include?(key) }

        return if extra_keys.empty?

        "#{as} has unknown propert#{extra_keys.size == 1 ? 'y' : 'ies'} " \
          "#{extra_keys.map(&:inspect).join(', ')}"
      end

      def invalid_group_type_error(value, as:)
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

      def invalid_items_error(value, as:)
        value
          .each
          .with_index
          .map do |item, index|
            Librum::Components::Bulma::Forms::SelectOption
              .validate_option(item, as: "#{as} item #{index}")
          end
          .compact
          .join(', ')
          .presence
      end

      def invalid_type_error(value, as:)
        return if value.is_a?(Array)

        SleepingKingStudios::Tools::Toolbelt
          .instance
          .assertions
          .error_message_for(
            'sleeping_king_studios.tools.assertions.instance_of',
            as:,
            expected: Array
          )
      end

      def missing_keys_error(value, as:)
        missing = EXPECTED_KEYS.reject { |key| value.key?(key) }

        return if missing.empty?

        "#{as} is missing required propert#{missing.size == 1 ? 'y' : 'ies'} " \
          "#{missing.map(&:inspect).join(', ')}"
      end
    end

    option :label,
      required: true,
      validate: String
    option :selected_value,
      validate: String
    option :values,
      validate: true

    # Renders the component.
    def call
      content_tag('optgroup', label:) do
        buffer = ActiveSupport::SafeBuffer.new

        values.each { |item| buffer << render_value(**item) << "\n" }

        buffer
      end
    end

    # @return [true, false] true if the option group contains any options;
    #   otherwise false.
    def render?
      values.present?
    end

    private

    def render_value(label:, value: nil, disabled: false)
      component = Librum::Components::Bulma::Forms::SelectOption.new(
        label:,
        value:,
        disabled:,
        selected: selected_value == (value || label)
      )

      render(component)
    end

    def validate_values(value, as: 'values')
      self.class.validate_options(value, as:)
    end
  end
end
