# frozen_string_literal: true

require 'librum/components'

module Librum::Components::Bulma::Forms
  # Renders a form textarea input.
  #
  # @see https://bulma.io/documentation/form/textarea/
  class TextArea < Librum::Components::Bulma::Base
    include Librum::Components::Options::ClassName

    option :color,       validate: true
    option :disabled,    boolean:  true
    option :fixed_size,  boolean:  true
    option :id,          validate: String
    option :name,        validate: String
    option :placeholder, validate: String
    option :read_only,   boolean:  true
    option :required,    boolean:  true
    option :rows,        validate: Integer
    option :size,        validate: true
    option :value

    # Generates the form input.
    #
    # @return [ActiveSupport::SafeBuffer] the presented data.
    def call
      content_tag('textarea', **text_area_attributes) { value }
    end

    private

    def text_area_class_name
      class_names(
        bulma_class_names(
          'textarea',
          color ? "is-#{color}" : nil,
          size  ? "is-#{size}"  : nil
        ),
        class_name
      )
    end

    def text_area_attributes
      {
        id:,
        name:,
        class:       text_area_class_name,
        disabled:    disabled?,
        placeholder:,
        readonly:    read_only?,
        required:    required?,
        rows:
      }.compact
    end
  end
end
