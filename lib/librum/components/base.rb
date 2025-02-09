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

    # @return [Hash] additional options passed to the component.
    attr_reader :options

    private

    def components
      EMPTY_COMPONENTS
    end
  end
end
