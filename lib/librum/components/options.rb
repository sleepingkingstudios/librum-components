# frozen_string_literal: true

require 'sleeping_king_studios/tools/toolbox/mixin'

require 'librum/components'

module Librum::Components
  # Module for defining named options for components.
  module Options # rubocop:disable Metrics/ModuleLength
    extend SleepingKingStudios::Tools::Toolbox::Mixin

    autoload :ClassName, 'librum/components/options/class_name'

    # Exception raised when defining an option that already exists.
    class DuplicateOptionError < StandardError; end

    # Exception raised when creating a component with unrecognized option.
    class InvalidOptionsError < ArgumentError; end

    # Class methods to extend when including Options.
    module ClassMethods
      # Flags the component as accepting unexpected options.
      #
      # If called, updates #allow_extra_options? to true. Unexpected options
      # passed to the constructor will be ignored, rather than raising an
      # exception.
      def allow_extra_options = @allow_extra_options = true

      # @return [true, false] if true, ignores unexpected options rather than
      #   raising an exception.
      def allow_extra_options? = @allow_extra_options || false

      # Defines an option for the component.
      #
      # A note on defaults and validation: options can have a default value that
      # is defined as a Proc. By default, this is lazily evaluated within the
      # context of the component, meaning it can reference other option values.
      # However, required options and options with validations need to evaluate
      # the default value at initialization, and cannot reference the component
      # or its properties.
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
      #
      # @example Define An Option
      #   class CustomComponent
      #     include Librum::Components::Options
      #
      #     option :label
      #
      #     option :checked, boolean: true
      #   end
      #
      #   component = CustomComponent.new(label: 'Click Me')
      #   component.label    #=> 'Click Me'
      #   component.checked? #=> false
      #
      # @example Define A Required Option
      #   class CustomComponent
      #     include Librum::Components::Options
      #
      #     option :disclaimer, required: true
      #   end
      #
      #   CustomComponent.new
      #   #=> raises InvalidOptionsError, "disclaimer can't be blank"
      #
      # @example Define A Validated Option
      #   class CustomComponent
      #     include Librum::Components::Options
      #
      #     option :license, validate: true
      #
      #     private
      #
      #     def validate_license(value, :as)
      #       return if value =~ /MIT/
      #
      #       'project must use the MIT License'
      #     end
      #   end
      #
      #   CustomComponent.new(license: 'LGPL')
      #   #=> raises InvalidOptionsError, 'project must use the MIT license'
      #
      # @example Define An Option With Block Validation
      #   class CustomComponent
      #     include Librum::Components::Options
      #
      #     option :checked,
      #       validate: ->(value) { value == 4 ? nil : 'there are four lights' }
      #   end
      #
      #   CustomComponent.new(lights: 5)
      #   #=> raises InvalidOptionsError, 'there are four lights'
      #
      # @example Define An Option With Method Validation
      #   class CustomComponent
      #     include Librum::Components::Options
      #
      #     option :checked,
      #       boolean:  true
      #       validate: :boolean
      #
      #     option :checked_popover,
      #       validate: :popover_text
      #
      #     private
      #
      #     def validate_popover_text(value, as:)
      #       return if value.nil? || value.length < 20
      #
      #       "#{as} is too long"
      #     end
      #   end
      #
      #   CustomComponent.new(checked: nil)
      #   #=> raises InvalidOptionsError, 'checked must be true or false'
      #
      #   checked_popover = "Neque porro quisquam est qui dolorem ipsum quia..."
      #   CustomComponent.new(checked_popover:)
      #   #=> raises InvalidOptionsError, 'checked_popover is too long'
      #
      # @example Define An Option With Type Validation
      #   class CustomComponent
      #     include Librum::Components::Options
      #
      #     option :counter, validate: Integer
      #   end
      #
      #   CustomComponent.new(counter: 'threeve')
      #   #=> raises InvalidOptionsError, 'counter is not an instance of Integer'
      #
      # @example Define An Option With Multiple Validations
      #   class CustomComponent
      #     include Librum::Components::Options
      #
      #     option :rgb_color, validate: {
      #       presence: true,
      #       matches:  /\d{1,3}, \d{1,3}, \d{1,3}/
      #     }
      #   end
      #
      #   CustomComponent.new
      #   #=> raises InvalidOptionsError, "rgb_color can't be blank"
      #
      #   CustomComponent.new(rgb_color: 'blue')
      #   #=> raises InvalidOptionsError, 'rgb_color does not match the pattern'
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

        option_name = "##{name}#{'?' if boolean}"

        message =
          "unable to define option #{option_name} - the option is already " \
          "defined on #{parent_component}"

        raise DuplicateOptionError, message
      end
    end

    # @param options [Hash] additional options passed to the component.
    def initialize(**options)
      super()

      @options = apply_default_options(options)
      @options = validate_options(options)
    end

    # @return [Hash] additional options passed to the component.
    attr_reader :options

    private

    def apply_default_options(options)
      self.class.options.each.with_object(options) do |(key, option), hsh|
        next if hsh.key?(key.intern)
        next unless option.required? || option.validate?

        hsh[key.intern] =
          option.default.is_a?(Proc) ? option.default.call : option.default
      end
    end

    def find_extra_options(options)
      return [] if self.class.allow_extra_options?

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

      return if configuration.colors.include?(value)

      "#{as} is not a valid color name"
    end

    def validate_icon(value, as: 'icon')
      return if value.nil?
      return if value.is_a?(String)
      return if value.is_a?(Hash) && value.key?(:icon)
      return if value.is_a?(ViewComponent::Base)

      "#{as} is not a valid icon"
    end

    def validate_inclusion(value, expected:, as: '')
      return if value.nil?
      return if expected.include?(value)

      "#{as} is not included in the list"
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
      when Hash
        validate_option_hash(aggregator:, option:, value:)
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

    def validate_option_hash(aggregator:, option:, value:) # rubocop:disable Metrics/MethodLength
      option.validate.each do |method_name, expected|
        validation_method = "validate_#{method_name}"

        keywords = { as: option.name }
        keywords[:expected] = expected unless expected == true

        if aggregator.respond_to?(validation_method)
          aggregator.public_send(validation_method, value, **keywords)
        else
          message = send(validation_method, value, **keywords)

          aggregator << message if message.present?
        end
      end
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

      message = send(validation_method, value, as: option.name)

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
