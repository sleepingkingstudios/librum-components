# frozen_string_literal: true

require 'librum/components'

module Librum::Components::Bulma::Forms
  # Renders a form control.
  #
  # @see https://bulma.io/documentation/form/general/
  class Field < Librum::Components::Bulma::Base # rubocop:disable Metrics/ClassLength
    include Librum::Components::Options::ClassName

    allow_extra_options

    option :color,      validate: true
    option :icon_left,  validate: :icon
    option :icon_right, validate: :icon
    option :inline?,    boolean:  true, default: true
    option :label,      validate: true
    option :message,    validate: :label
    option :name,       validate: String, required: true
    option :type,       default:  'text', required: true, validate: :name

    # Generates the form field.
    #
    # @return [ActiveSupport::SafeBuffer] the rendered input.
    def call
      content_tag('div', class: field_class_name) do
        buffer = ActiveSupport::SafeBuffer.new
        buffer << render_label << "\n"
        buffer << render_control
        buffer << render_message if message
        buffer
      end
    end

    private

    def build_input
      case type
      when 'checkbox'
        build_checkbox_input
      when 'select'
        build_select_input
      when 'textarea'
        build_text_area
      else
        build_text_input
      end
    end

    def build_checkbox_input
      build_component(
        components::Forms::Checkbox,
        **options,
        label: label || extract_label
      )
    end

    def build_component(component_class, **options)
      options = component_class.filter_options(options.except(:class_name))

      component_class.new(**options)
    end

    def build_select_input
      build_component(
        components::Forms::Select,
        full_width: true,
        **options
      )
    end

    def build_text_area
      build_component(components::Forms::TextArea, **options)
    end

    def build_text_input
      build_component(components::Forms::Input, **options)
    end

    def control_class_name
      bulma_class_names(
        'control',
        icon_left  ? 'has-icons-left'  : nil,
        icon_right ? 'has-icons-right' : nil,
        type == 'checkbox' && !inline? ? 'px-1 py-2' : nil
      )
    end

    def extract_label
      name.split('[').last.sub(']', '').titleize
    end

    def field_class_name
      class_names(
        bulma_class_names('field'),
        class_name
      )
    end

    def message_class_name
      class_names(
        bulma_class_names('help'),
        color ? "is-#{color}" : nil
      )
    end

    def render_control
      content_tag('div', class: control_class_name) do
        buffer = ActiveSupport::SafeBuffer.new

        buffer << render_input
        buffer << render_icon(icon_left, 'left')
        buffer << render_icon(icon_right, 'right')

        buffer
      end
    end

    def render_empty_label
      content_tag('label', class: bulma_class_names('label')) { "\u00A0" }
    end

    def render_icon(icon, direction)
      return unless icon

      return render(icon) if icon.is_a?(ViewComponent)

      icon = { icon: } if icon.is_a?(String)
      icon = {
        **icon,
        class_name: bulma_class_names("is-#{direction}"),
        size:       'small'
      }

      component = Librum::Components::Bulma::Icon.build(icon)

      render(component)
    end

    def render_input
      component = build_input

      render(component) if component
    end

    def render_label # rubocop:disable Metrics/AbcSize
      return if type == 'checkbox' && inline?

      return render_empty_label if type == 'checkbox'

      return render(label) if label.is_a?(ViewComponent::Base)

      return label if label.is_a?(ActiveSupport::SafeBuffer)

      content_tag('label', class: bulma_class_names('label')) do
        strip_tags(label || extract_label)
      end
    end

    def render_message
      return render(message) if message.is_a?(ViewComponent::Base)

      return message if message.is_a?(ActiveSupport::SafeBuffer)

      content_tag('p', class: message_class_name) do
        strip_tags(message)
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
