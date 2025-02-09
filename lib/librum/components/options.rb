# frozen_string_literal: true

require 'sleeping_king_studios/tools/toolbox/mixin'

require 'librum/components'

module Librum::Components
  # Module for defining named options for components.
  module Options
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
      #
      # @return [Symbol] the name of the generated method.
      def option(name, boolean: false, default: nil)
        option = Librum::Components::Option.new(boolean:, default:, name:)

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

    def invalid_options_message(extra_options) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      format_options =
        extra_options
        .map { |key, value| "#{key}: #{value.inspect}" }
        .join(', ')
      message = "invalid options #{format_options} -"

      if self.class.options.empty?
        "#{message} #{self.class.name} does not define any valid options"
      else
        valid_options = self.class.options.keys.sort.map { |key| ":#{key}" }
        valid_options = tools.array_tools.humanize_list(valid_options)

        "#{message} valid options for #{self.class.name} are #{valid_options}"
      end
    end

    def tools
      SleepingKingStudios::Tools::Toolbelt.instance
    end

    def validate_options(options)
      extra_options =
        options.reject { |key, _| self.class.options.key?(key.to_s) }

      return options if extra_options.empty?

      raise InvalidOptionsError, invalid_options_message(extra_options)
    end
  end
end
