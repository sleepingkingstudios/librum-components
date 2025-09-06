# frozen_string_literal: true

require 'rails'
require 'view_component'

require 'plumbum/consumer'
require 'plumbum/parameters'
require 'sleeping_king_studios/tools/toolbelt'

require 'librum/components'
require 'librum/components/empty'
require 'librum/components/errors/abstract_component_error'
require 'librum/components/option'
require 'librum/components/options'

module Librum::Components
  # Abstract base class for component objects.
  class Base < ViewComponent::Base
    include Librum::Components::Options
    include Plumbum::Consumer
    prepend Plumbum::Parameters

    provider Librum::Components::Provider

    dependency :components,    optional: true
    dependency :configuration, optional: true

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
      #   @raise [Librum::Components::Errors::InvalidComponentError] if the
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
          raise Librum::Components::Errors::InvalidComponentError,
            "#{maybe_component.inspect} is not an instance of #{self}"
        end

        raise Librum::Components::Errors::InvalidComponentError,
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

        raise Librum::Components::Errors::AbstractComponentError, message
      end
    end

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

    # @return [Module] the class scope for the component library.
    def components
      # @todo: Replace this with dependency(default:).
      super || default_components
    end

    # @return [Librum::Core::Configuration] the configuration for the component
    #   library.
    def configuration
      # @todo: Replace this with dependency(default:).
      super || default_configuration
    end

    # @return [true, false] if true, indicates that the component represents a
    #   full-page layout. Defaults to false.
    def is_layout? = false # rubocop:disable Naming/PredicatePrefix

    private

    def default_components
      Librum::Components::Empty
    end

    def default_configuration
      Librum::Components::Configuration.default
    end

    def present?(value)
      return false if value.nil?

      return true if value.is_a?(ViewComponent::Base)

      value.respond_to?(:empty?) && !value.empty?
    end
  end
end
