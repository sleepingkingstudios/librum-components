# frozen_string_literal: true

require 'librum/components'

module Librum::Components
  # Helper class for generating form components.
  class Form::Builder
    # @param fields [Array] the fields array used to store inputs.
    # @param form [Librum::Components::Form] the form used to generate inputs.
    def initialize(fields:, form:)
      @fields = fields
      @form   = form
    end

    # @return [Array] the fields array used to store inputs.
    attr_reader :fields

    # @return [Librum::Components::Form] the form used to generate inputs.
    attr_reader :form

    # @overload buttons(**options)
    #   Generates the form buttons and appends them to the form fields.
    #
    #   @param options [Hash] additional options to pass to the buttons.
    #
    #   @return [self] the builder instance.
    def buttons(**)
      fields << form.buttons(**)

      self
    end

    # @overload checkbox(name, **options)
    #   Generates a checkbox input and appends it to the form fields.
    #
    #   @param name [String] the name of the input.
    #   @param options [Hash] additional options to pass to the input.
    #
    #   @return [self] the builder instance.
    def checkbox(name, **)
      fields << form.checkbox(name, **)

      self
    end

    # @overload input(name, **options)
    #   Generates a form input and appends it to the form fields.
    #
    #   @param name [String] the name of the input.
    #   @param options [Hash] additional options to pass to the input.
    #
    #   @return [self] the builder instance.
    def input(name, **)
      fields << form.input(name, **)

      self
    end

    # @overload select(name, **options)
    #   Generates a select input and appends it to the form fields.
    #
    #   @param name [String] the name of the input.
    #   @param options [Hash] additional options to pass to the input.
    #
    #   @return [self] the builder instance.
    def select(name, **)
      fields << form.select(name, **)

      self
    end

    # @overload text_area(name, **options)
    #   Generates a textarea input and appends it to the form fields.
    #
    #   @param name [String] the name of the input.
    #   @param options [Hash] additional options to pass to the input.
    #
    #   @return [self] the builder instance.
    def text_area(name, **)
      fields << form.text_area(name, **)

      self
    end
  end
end
