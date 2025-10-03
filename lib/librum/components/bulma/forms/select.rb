# frozen_string_literal: true

require 'librum/components'

module Librum::Components::Bulma::Forms
  # Renders a form select input.
  #
  # @see https://bulma.io/documentation/form/input/
  class Select < Librum::Components::Bulma::Base # rubocop:disable Metrics/ClassLength
    include Librum::Components::Options::ClassName

    NO_SELECTION = Object.new.freeze
    private_constant :NO_SELECTION

    class << self
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

      def invalid_items_error(value, as:)
        value
          .each
          .with_index
          .map { |item, index| validate_item(item, as:, index:) }
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

      def validate_item(item, as:, index:)
        return if item == :hr

        if item.is_a?(Hash) && item.key?(:items)
          Librum::Components::Bulma::Forms::SelectOptionGroup
            .validate_option_group(item, as: "#{as} item #{index}")
        else
          Librum::Components::Bulma::Forms::SelectOption
            .validate_option(item, as: "#{as} item #{index}")
        end
      end
    end

    option :color,       validate: true
    option :disabled,    boolean:  true
    option :full_width,  boolean:  true
    option :id,          validate: String
    option :multiple,    boolean:  true
    option :name,        validate: String
    option :placeholder, validate: String
    option :required,    boolean:  true
    option :size,        validate: true
    option :value,       validate: String
    option :values,      required: true, validate: true

    # Generates the form select input.
    #
    # @return [ActiveSupport::SafeBuffer] the rendered input.
    def call
      content_tag('div', class: div_class_name) do
        content_tag('select', **select_attributes) do
          buffer = ActiveSupport::SafeBuffer.new

          buffer << render_placeholder << "\n" if placeholder

          values.each { |item| buffer << render_value(item) << "\n" }

          buffer
        end
      end
    end

    private

    def div_class_name
      class_names(
        bulma_class_names('select'),
        color       ? "is-#{color}" : nil,
        full_width? ? 'is-block'    : nil,
        multiple?   ? 'is-multiple' : nil,
        size        ? "is-#{size}"  : nil,
        class_name
      )
    end

    def flatten_options
      return @flatten_options if @flatten_options

      @flatten_options = values.reduce([]) do |ary, item|
        next ary unless item.is_a?(Hash)

        next ary.concat(item[:items]) if item.key?(:items)

        ary << item
      end
    end

    def render_option(label:, value: nil, disabled: false)
      component = Librum::Components::Bulma::Forms::SelectOption.new(
        label:,
        value:,
        disabled:,
        selected: selected_value == (value || label)
      )

      render(component)
    end

    def render_option_group(items:, label:)
      component = Librum::Components::Bulma::Forms::SelectOptionGroup.new(
        label:,
        selected_value: selected_value == NO_SELECTION ? nil : selected_value,
        values:         items
      )

      render(component)
    end

    def render_placeholder
      component = Librum::Components::Bulma::Forms::SelectOption.new(
        label:    placeholder,
        value:    '',
        disabled: false,
        selected: selected_value == NO_SELECTION
      )

      render(component)
    end

    def render_value(item)
      return tag.hr if item == :hr

      return render_option(**item) unless item.key?(:items)

      render_option_group(**item)
    end

    def select_attributes
      {
        disabled: disabled?,
        id:,
        multiple: multiple?,
        name:,
        required: required?
      }.compact
    end

    def selected_value
      return @selected_value if @selected_value

      options = flatten_options

      selected = options.find { |hsh| hsh[:selected] }

      return @selected_value = selected.fetch(:value, :label) if selected

      matching =
        options.find { |hsh| hsh.fetch(:value, hsh[:label]) == value }

      if matching
        return @selected_value = matching.fetch(:value, matching[:label])
      end

      @selected_value = NO_SELECTION
    end

    def validate_values(value, as: 'values')
      self.class.validate_options(value, as:)
    end
  end
end
