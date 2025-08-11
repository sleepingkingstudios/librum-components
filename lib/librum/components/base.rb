# frozen_string_literal: true

require 'rails'
require 'view_component'

require 'sleeping_king_studios/tools/toolbelt'

require 'librum/components'
require 'librum/components/option'
require 'librum/components/options'

module Librum::Components
  # Abstract base class for component objects.
  class Base < ViewComponent::Base
    include Librum::Components::Options

    EMPTY_COMPONENTS = Module.new
    private_constant :EMPTY_COMPONENTS

    # Exception raised when defining options on an abstract component.
    class AbstractComponentError < StandardError; end

    # Exception raised when building a component with invalid parameters.
    class InvalidComponentError < StandardError; end

    class << self
      # @return [true, false] true if the component class is an abstract class;
      #   otherwise returns false.
      def abstract?
        self == Librum::Components::Base
      end

      # @overload build(component)
      #   Asserts that the component is an instance of the class and returns.
      #
      #   @param component [Librum::Components::Base] the component to evaluate.
      #
      #   @return [Librum::Components::Base] the component.
      #
      #   @raise [Librum::Components::Base::InvalidComponentError] if the
      #     component is not an instance of the class.
      #
      # @overload build(options)
      #   Builds an instance of the component with the given options.
      #
      #   @param options [Hash] the options for the component.
      #
      #   @return [Librum::Components::Base] the component.
      #
      #   @raise [Librum::Components::Options::InvalidOptionsError] if the
      #     options are not valid for the class.
      def build(maybe_component)
        return maybe_component        if maybe_component.is_a?(self)
        return new(**maybe_component) if maybe_component.is_a?(Hash)

        if maybe_component.is_a?(ViewComponent::Base)
          raise InvalidComponentError,
            "#{maybe_component.inspect} is not an instance of #{self}"
        end

        raise InvalidComponentError,
          'unable to build component with parameters ' \
          "#{maybe_component.inspect}"
      end

      # (see Librum::Components::Options::ClassMethods#option)
      def option(name, boolean: false, **)
        handle_abstract_class!(name, boolean:)

        super
      end

      private

      def handle_abstract_class!(name, boolean: false)
        return unless abstract?

        option_name = "##{name}#{'?' if boolean}"

        message =
          "unable to define option #{option_name} - #{self.name} " \
          'is an abstract class'

        raise AbstractComponentError, message
      end
    end

    # @overload initialize(configuration: nil, **options)
    #   @param configuration [Librum::Core::Configuration] the configuration for
    #     the component library.
    #   @param options [Hash] additional options passed to the component.
    def initialize(configuration: nil, **)
      @configuration =
        configuration || Librum::Components::Configuration.instance

      super(**)
    end

    # @return [Librum::Core::Configuration] the configuration for the component
    #   library.
    attr_reader :configuration

    # @overload class_names(*args, prefix: nil)
    #   Combines the given class names and applies a prefix, if any.
    #
    #   Input arguments are processed as follows:
    #
    #   - Nil or false arguments are ignored.
    #   - String and symbol arguments are split by whitespace and added.
    #   - Array arguments are flattened.
    #   - Hash arguments are mapped to a list of keys with truthy values and
    #     flattened.
    #   - All other arguments are converted to strings.
    #
    #   Finally, the items are rendered unique and then combined into a
    #   space-separated string.
    #
    #   @param args [Array] the input arguments to combine.
    #   @param prefix [String] if given, each item in the output is prefixed
    #     with the specified string.
    #
    #   @return [String] the combined output string.
    def class_names(*, prefix: nil)
      return super(*) if prefix.blank?

      super(*).split.map { |str| "#{prefix}#{str}" }.join(' ')
    end

    private

    def components
      EMPTY_COMPONENTS
    end
  end
end
