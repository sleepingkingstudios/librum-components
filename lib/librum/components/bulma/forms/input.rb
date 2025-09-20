# frozen_string_literal: true

require 'librum/components'

module Librum::Components::Bulma::Forms
  # Renders a form text input.
  #
  # @see https://bulma.io/documentation/form/input/
  class Input < Librum::Components::Bulma::Base
    include Librum::Components::Options::ClassName

    option :color,       validate: true
    option :disabled,    boolean:  true
    option :id,          validate: String
    option :name,        validate: String
    option :placeholder, validate: String
    option :read_only,   boolean:  true
    option :required,    boolean:  true
    option :size,        validate: true
    option :static,      boolean:  true
    option :type,        default:  'text', required: true, validate: :name
    option :value

    # Generates the form input.
    #
    # @return [ActiveSupport::SafeBuffer] the rendered input.
    def call
      tag.input(**input_attributes)
    end

    private

    def input_attributes # rubocop:disable Metrics/MethodLength
      {
        id:,
        name:,
        class:       input_class_name,
        disabled:    disabled?,
        placeholder:,
        readonly:    read_only? || static?,
        required:    required?,
        type:,
        value:
      }.compact
    end

    def input_class_name
      class_names(
        bulma_class_names(
          'input',
          color    ? "is-#{color}"   : nil,
          size     ? "is-#{size}"    : nil,
          static?  ? 'is-static'     : nil
        ),
        class_name
      )
    end
  end
end
