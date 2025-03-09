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

    class << self
      # @return [true, false] true if the component class is an abstract class;
      #   otherwise returns false.
      def abstract?
        self == Librum::Components::Base
      end

      # Defines an option for the component.
      def option(name, boolean: false, default: nil)
        handle_abstract_class!(name, boolean:)

        super
      end

      private

      def handle_abstract_class!(name, boolean: false)
        return unless abstract?

        option_name = "##{name}#{boolean ? '?' : ''}"

        message =
          "unable to define option #{option_name} - #{self.name} " \
          'is an abstract class'

        raise AbstractComponentError, message
      end
    end

    # Combines the given class names and applies a prefix, if any.
    #
    # Nil or false arguments are ignored. String and symbol arguments are split
    # by whitespace and added. Array arguments are flattened. Hash arguments are
    # mapped to a list of keys with truthy values and flattened. All other
    # arguments are converted to strings. Finally, the items are rendered unique
    # and then combined into a space-separated string.
    #
    # @param args [Array] the input arguments to combine.
    # @param prefix [String] if given, each item in the output is prefixed with
    #   the specified string.
    #
    # @return [String] the combined output string.
    def class_names(*args, prefix: nil)
      return super(*args) if prefix.blank?

      super(*args).split(' ').map { |str| "#{prefix}#{str}" }.join(' ')
    end

    private

    def components
      EMPTY_COMPONENTS
    end
  end
end
