# frozen_string_literal: true

require 'librum/components'

module Librum::Components
  # Value class representing an optional parameter for a component.
  Option = Data.define(:name, :boolean, :default, :required, :validate) do
    # @param name [String, Symbol] the name of the option.
    # @param boolean [true, false] if true, indicates that the option is a
    #   boolean option and should have only true or false values.
    # @param default [Proc, Object] the default value for the object.
    # @param required [true, false] if true, indicates that the option is
    #   required for the component.
    # @param validate [Symbol, Class, Proc, nil] the validation for the option,
    #   if any.
    def initialize(
      name:,
      boolean:  false,
      default:  nil,
      required: false,
      validate: nil
    )
      name = name.to_s
      name = name.sub(/\?\z/, '') if boolean

      boolean = false if boolean.nil?
      default = false if boolean && default.nil?

      super(boolean:, name:, default:, required:, validate:)
    end

    # @return [true, false] if true, indicates that the option is a boolean
    #   option and should have only true or false values.
    def boolean?
      boolean
    end

    # @return [true, false] if true, the option defines a default value.
    def default?
      !default.nil?
    end

    # @return [true, false] if true, indicates that the option is required for
    #   the component.
    def required?
      required
    end

    # @return [true, false] if true, the option defines a validation.
    def validate?
      !validate.nil?
    end
  end
end
