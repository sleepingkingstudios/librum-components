# frozen_string_literal: true

require 'sleeping_king_studios/tools/toolbox/mixin'

require 'librum/components'

module Librum::Components
  # Module for defining named options for components.
  module Options # rubocop:disable Metrics/ModuleLength
    extend SleepingKingStudios::Tools::Toolbox::Mixin

    # Exception raised when defining an option that already exists.
    class DuplicateOptionError < StandardError; end

    # Exception raised when creating a component with unrecognized option.
    class InvalidOptionsError < ArgumentError; end

    # Class methods to extend when including Options.
    module ClassMethods
      # Defines an option for the component.
      #
      # @param name [String, Symbol] the name of the option.
      # @param boolean [true, false] if true, the option is a boolean and will
      #   generate a predicate method.
      # @param default [Proc, Object] the default value for the option.
      # @param required [true, false] if true, indicates that the option is
      #   required for the component.
      # @param validate [Symbol, Class, Proc, nil] the validation for the
      #   option, if any.
      #
      # @return [Symbol] the name of the generated method.
      def option( # rubocop:disable Metrics/MethodLength
        name,
        boolean: false,
        default: nil,
        required: false,
        validate: nil
      )
        option =
          Librum::Components::Option.new(
            boolean:,
            default:,
            name:,
            required:,
            validate:
          )

        handle_duplicate_option!(name, boolean:)

        defined_options[option.name] = option

        if boolean
          define_predicate(option.name, default: option.default)
        else
          define_reader(option.name, default: option.default)
        end
      end

      # @return [Hash{String=>Option}] the defined options for the component.
      def options
        @options ||=
          ancestors
          .select { |ancestor| ancestor.respond_to?(:defined_options, true) }
          .reduce({}) { |hsh, ancestor| hsh.merge(ancestor.defined_options) }
      end

      protected

      def defined_options
        @defined_options ||= {}
      end

      private

      def define_reader(name, default:)
        name = name.intern

        if default.is_a?(Proc)
          define_method(name) { options.fetch(name, instance_exec(&default)) }
        else
          define_method(name) { options.fetch(name, default) }
        end

        name
      end

      def define_predicate(name, default:)
        name           = name.intern
        predicate_name = :"#{name}?"

        if default.is_a?(Proc)
          define_method(predicate_name) do
            options.fetch(name, instance_exec(&default))
          end
        else
          define_method(predicate_name) { options.fetch(name, default) }
        end

        predicate_name
      end

      def find_duplicate_option(name)
        name = name.to_s

        ancestors
          .select { |ancestor| ancestor.respond_to?(:defined_options, true) }
          .find { |ancestor| ancestor.defined_options.key?(name) }
      end

      def handle_duplicate_option!(name, boolean:)
        parent_component = find_duplicate_option(name)

        return unless parent_component

        option_name = "##{name}#{boolean ? '?' : ''}"

        message =
          "unable to define option #{option_name} - the option is already " \
          "defined on #{parent_component}"

        raise DuplicateOptionError, message
      end
    end

    # @param options [Hash] additional options passed to the component.
    def initialize(**options)
      super()

      @options = validate_options(options)
    end

    # @return [Hash] additional options passed to the component.
    attr_reader :options

    private

    def find_extra_options(options)
      options.each_key.reject { |key| self.class.options.key?(key.to_s) }
    end

    def invalid_options_message(extra_keys:, failure_message:)
      return failure_message if extra_keys.empty?

      if self.class.options.empty?
        "#{failure_message} - #{self.class.name} does not define any valid " \
          'options'
      else
        valid_options = self.class.options.keys.sort.map { |key| ":#{key}" }
        valid_options = tools.array_tools.humanize_list(valid_options)

        "#{failure_message} - valid options for #{self.class.name} are " \
          "#{valid_options}"
      end
    end

    def tools
      SleepingKingStudios::Tools::Toolbelt.instance
    end

    def validate_color(value, as: 'color')
      return if value.nil?

      return if configuration.colors.include?('value')

      "#{as} is not a valid color name"
    end

    def validate_option(aggregator:, option:, value:) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/MethodLength
      failures = aggregator.size

      aggregator.validate_presence(value, as: option.name) if option.required?

      return unless option.validate?

      # Skip additional validation for missing required options.
      return unless aggregator.size == failures

      case option.validate
      when true
        validate_option_name(aggregator:, option:, value:)
      when String, Symbol
        validate_option_method(aggregator:, option:, value:)
      when Module
        validate_option_class(aggregator:, option:, value:)
      when Proc
        validate_option_block(aggregator:, option:, value:)
      end
    end

    def validate_option_block(aggregator:, option:, value:)
      validator  = option.validate
      message    =
        if validator_accepts_name_parameter?(validator)
          validator.call(value, as: option.name)
        else
          validator.call(value)
        end

      aggregator << message if message.present?
    end

    def validate_option_class(aggregator:, option:, value:)
      aggregator
        .validate_instance_of(value, expected: option.validate, as: option.name)
    end

    def validate_option_method(aggregator:, option:, value:)
      validation_method = "validate_#{option.validate}"

      if aggregator.respond_to?(validation_method)
        aggregator.public_send(validation_method, value, as: option.name)
      else
        message = send(validation_method, value, as: option.name)

        aggregator << message if message.present?
      end
    end

    def validate_option_name(aggregator:, option:, value:)
      validation_method = "validate_#{option.name}"

      message = public_send(validation_method, value, as: option.name)

      aggregator << message if message.present?
    end

    def validate_options(options) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      aggregator = tools.assertions.aggregator_class.new
      extra_keys = find_extra_options(options)

      extra_keys.each { |key| aggregator << "#{key} is not a valid option" }

      self.class.options.each_value do |option|
        validate_option(
          aggregator:,
          option:,
          value:      options[option.name.intern]
        )
      end

      return options if aggregator.empty?

      raise InvalidOptionsError,
        invalid_options_message(
          extra_keys:,
          failure_message: aggregator.failure_message
        )
    end

    def validator_accepts_name_parameter?(validator)
      parameters = validator.parameters

      parameters.any? do |type, name|
        name == :as && (type == :key || type == :keyreq) # rubocop:disable Style/MultipleComparison
      end
    end
  end
end
