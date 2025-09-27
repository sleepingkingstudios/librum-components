# frozen_string_literal: true

require 'librum/components'

module Librum::Components::Bulma::Forms
  # Renders a form checkbox input.
  #
  # @see https://bulma.io/documentation/form/checkbox/
  class Checkbox < Librum::Components::Bulma::Base
    option :checked,  boolean:  true
    option :disabled, boolean:  true
    option :id,       validate: String
    option :label,    validate: true
    option :name,     validate: String
    option :required, boolean:  true
    option :value,    validate: String

    # Generates the form select input.
    #
    # @return [ActiveSupport::SafeBuffer] the rendered input.
    def call
      content_tag('label', class: bulma_class_names('checkbox')) do
        buffer = ActiveSupport::SafeBuffer.new
        buffer << render_hidden_input << "\n"
        buffer << render_checkbox
        buffer << render_label if label
        buffer
      end
    end

    private

    def checkbox_attributes
      {
        id:,
        name:,
        type:     'checkbox',
        checked:  checked?,
        disabled: disabled?,
        required: required?,
        value:    value || '1'
      }.compact
    end

    def hidden_attributes
      {
        autocomplete: 'off',
        name:,
        type:         'hidden',
        disabled:     disabled?,
        value:        '0'
      }.compact
    end

    def render_checkbox
      tag.input(**checkbox_attributes)
    end

    def render_hidden_input
      tag.input(**hidden_attributes)
    end

    def render_label
      return render(label) if label.is_a?(ViewComponent::Base)

      return label if label.is_a?(ActiveSupport::SafeBuffer)

      content_tag('span', class: bulma_class_names('ml-1')) do
        strip_tags(label)
      end
    end

    def validate_label(value, as: 'label')
      return if value.nil?
      return if value.is_a?(String)
      return if value.is_a?(ActiveSupport::SafeBuffer)
      return if value.is_a?(ViewComponent::Base)

      "#{as} is not a String or a component"
    end
  end
end
