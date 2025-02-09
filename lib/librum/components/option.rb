# frozen_string_literal: true

require 'librum/components'

module Librum::Components
  # Value class representing an optional parameter for a component.
  Option = Data.define(:name, :boolean, :default) do
    # @param name [String, Symbol] the name of the option.
    # @param boolean [true, false] if true, indicates that the option is a
    #   boolean option and should have only true or false values.
    # @param default [Proc, Object] the default value for the object.
    def initialize(name:, boolean: false, default: nil)
      name = name.to_s
      name = name.sub(/\?\z/, '') if boolean

      default = false if boolean && default.nil?

      super(boolean: boolean ? true : false, name:, default:)
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
  end
end
