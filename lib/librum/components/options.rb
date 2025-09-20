# frozen_string_literal: true

require 'sleeping_king_studios/tools/toolbox/mixin'

require 'librum/components'

module Librum::Components
  # Module for defining named options for components.
  module Options
    extend SleepingKingStudios::Tools::Toolbox::Mixin

    class << self
      # Callback invoked whenever Options is included in another module.
      def included(other)
        super

        other.include ValidationHelpers
      end
    end

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

      # Returns the subset of the options that are defined for the component.
      #
      # @param value [Hash] the options to filter.
      #
      # @return [Hash] the filtered options.
      def filter_options(value)
        return value if allow_extra_options?

        value.slice(*options_keys)
      end

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
      #   #=> raises Librum::Components::Errors::InvalidOptionsError,
      #         "disclaimer can't be blank"
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
      #   #=> raises Librum::Components::Errors::InvalidOptionsError,
      #         'project must use the MIT license'
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
      #   #=> raises Librum::Components::Errors::InvalidOptionsError,
      #         'there are four lights'
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
      #   #=> raises Librum::Components::Errors::InvalidOptionsError,
      #         'checked must be true or false'
      #
      #   checked_popover = "Neque porro quisquam est qui dolorem ipsum quia..."
      #   CustomComponent.new(checked_popover:)
      #   #=> raises Librum::Components::Errors::InvalidOptionsError,
      #         'checked_popover is too long'
      #
      # @example Define An Option With Type Validation
      #   class CustomComponent
      #     include Librum::Components::Options
      #
      #     option :counter, validate: Integer
      #   end
      #
      #   CustomComponent.new(counter: 'threeve')
      #   #=> raises Librum::Components::Errors::InvalidOptionsError,
      #         'counter is not an instance of Integer'
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
      #   #=> raises Librum::Components::Errors::InvalidOptionsError,
      #          "rgb_color can't be blank"
      #
      #   CustomComponent.new(rgb_color: 'blue')
      #   #=> raises Librum::Components::Errors::InvalidOptionsError,
      #         'rgb_color does not match the pattern'
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

        raise Librum::Components::Errors::DuplicateOptionError, message
      end

      def options_keys
        @options_keys ||= Set.new(options.keys.map(&:intern))
      end
    end

    # @param options [Hash] additional options passed to the component.
    def initialize(**options)
      super()

      @options = apply_default_options(options)

      validate_options(@options)
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

    def tools
      SleepingKingStudios::Tools::Toolbelt.instance
    end

    def validate_options(value)
      Librum::Components::Options::Validator
        .new(
          allow_extra_options: self.class.allow_extra_options?,
          options:             self.class.options
        )
        .call(component: self, value:)
    end
  end
end
