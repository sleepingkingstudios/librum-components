# frozen_string_literal: true

require 'librum/components'

module Librum::Components
  # Component displaying a structured data field, such as a table cell.
  class DataField < Librum::Components::Base # rubocop:disable Metrics/ClassLength
    include ActionView::Helpers::SanitizeHelper

    DEFAULTS = {
      align:     nil,
      label:     nil,
      transform: nil,
      truncate:  nil,
      type:      :text,
      value:     nil
    }.freeze
    private_constant :DEFAULTS

    DEFINITION_KEYS = DEFAULTS.keys.freeze
    private_constant :DEFINITION_KEYS

    DEFINITION_KEYS_SET = Set.new(DEFINITION_KEYS).freeze
    private_constant :DEFINITION_KEYS_SET

    # Definition for a structured data field, such as a table column.
    Definition = Data.define(:key, *DEFINITION_KEYS) do
      class << self
        # Converts a valid value to a definition instance.
        #
        # @param value [Definition, Hash] the value to convert.
        #
        # @return [Definition] the definition instance.
        def normalize(value)
          value.is_a?(Definition) ? value : new(**value)
        end

        # Validates a value as a field definition.
        #
        # - Verifies that the value is either a Hash or a Definition instance.
        # - Verifies that a Hash value has the required keys and does not have
        #   any unknown keys.
        #
        # @param value [Object] the value to validate.
        #
        # @return [String, nil] the error message, or nil if the value is a
        #   valid field definition.
        def validate(value, as: 'field')
          return if value.is_a?(Definition)

          return "#{as} is not a Hash or Definition" unless value.is_a?(Hash)

          unless value.key?(:key)
            return "#{as} is missing required property :key"
          end

          extra_keys = find_extra_keys(value)

          return if extra_keys.empty?

          "#{as} has unknown propert#{extra_keys.size == 1 ? 'y' : 'ies'} " \
            "#{extra_keys.map(&:inspect).join(', ')}"
        end

        # Validates a list of values as field definitions.
        #
        # - Verifies the list is an Array.
        # - Verifies that each item in the list is a valid field definition.
        #
        # @param value [Object] the value to validate.
        #
        # @return [String, nil] the error message, or nil if the value is a
        #   valid field definition.
        def validate_list(value, as: 'fields')
          message = validate_list_is_an_array(value, as:)

          return message if message

          value
            .each
            .with_index
            .map { |item, index| validate(item, as: "#{as} item #{index}") }
            .compact
            .join(', ')
            .then { |str| str.empty? ? nil : str }
        end

        private

        def find_extra_keys(value)
          value.keys.reject do |key|
            key == :key || DEFINITION_KEYS_SET.include?(key)
          end
        end

        def tools
          SleepingKingStudios::Tools::Toolbelt.instance
        end

        def validate_list_is_an_array(value, as:)
          return if value.is_a?(Array)

          tools.assertions.error_message_for(
            'sleeping_king_studios.tools.assertions.instance_of',
            as:,
            expected: Array
          )
        end
      end

      # @overload initialize(key:, **options)
      #   @param key [String] the name of the mapped data column.
      #   @param options [Hash] additional options for the definition.
      def initialize(key:, **)
        super(
          key:,
          **DEFAULTS,
          label: key.to_s.titleize,
          **
        )
      end
    end

    # @param options [Hash] additional options passed to the component.
    def initialize(**options)
      super

      @options[:field] = Definition.normalize(options[:field])
    end

    allow_extra_options

    option :data,  required: true

    option :field, required: true, validate: true

    # Formats the matching data value for the configured field.
    #
    # @return [ActiveSupport::SafeBuffer] the presented data.
    def call
      return render_value if field.value

      case field.type.intern
      when :actions then render_actions
      when :boolean then render_boolean
      when :text    then process_value(raw_value)
      else
        render_invalid
      end
    end

    private

    def process_value(value)
      value
        .then { |str| transform_value(str) }
        .then { |str| truncate_value(str) }
        .then { |str| scrub_value(str) }
    end

    def raw_value
      return data.public_send(field.key) if data.respond_to?(field.key)

      data[field.key]
    end

    def render_actions # rubocop:disable Metrics/MethodLength
      if components.const_defined?('Resources::TableActions')
        render components::Resources::TableActions.new(
          data:,
          resource: options[:resource],
          routes:   options[:routes]
        )
      else
        content_tag('span', style: 'color: #f00;') do
          'Missing Component Resources::TableActions'
        end
      end
    end

    def render_boolean
      scrub_value(raw_value ? 'True' : 'False')
    end

    def render_invalid # rubocop:disable Metrics/MethodLength
      if components.const_defined?('Label')
        render components::Label.new(
          color: configuration.danger_color,
          icon:  'bug',
          text:  "Unknown Type #{field.type.inspect}"
        )
      else
        content_tag('span', style: 'color: #f00;') do
          "Unknown Type #{field.type.inspect}"
        end
      end
    end

    def render_value # rubocop:disable Metrics/AbcSize
      return sanitize(field.value.call(data)) if field.value.is_a?(Proc)

      return render(field.value) if field.value.is_a?(ViewComponent::Base)

      if field.value.is_a?(Class)
        return render(field.value.new(**options.except(:field)))
      end

      sanitize(process_value(field.value))
    end

    def scrub_value(value)
      return if value.nil?

      return value if value.is_a?(ActiveSupport::SafeBuffer)

      sanitize(value, attributes: [], tags: [])
    end

    def transform_value(value) # rubocop:disable Metrics/AbcSize
      return value unless field.transform

      if field.transform.is_a?(String) || field.transform.is_a?(Symbol)
        return value.public_send(field.transform)
      end

      return field.transform.call(value) if field.transform.is_a?(Proc)

      value
    end

    def truncate_value(value)
      return value unless field.truncate

      length = field.truncate - 1

      return value if value.length <= length

      "#{value[0...length]}…"
    end

    def validate_field(value, as: 'field') = Definition.validate(value, as:)
  end
end
