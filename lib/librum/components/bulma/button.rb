# frozen_string_literal: true

require 'librum/components'

module Librum::Components::Bulma
  # Flexible button component.
  #
  # @see https://bulma.io/documentation/elements/button/
  class Button < Librum::Components::Bulma::Base # rubocop:disable Metrics/ClassLength
    include Librum::Components::Options::ClassName
    include Librum::Components::Options::DataAttributes

    # The valid option values for the :target option.
    LINK_TARGETS = Set.new(%w[blank self]).freeze

    option :color,       validate: true
    option :disabled,    boolean:  true
    option :http_method, default:  'post', validate: true
    option :icon,        validate: true
    option :loading,     boolean:  true
    option :remote
    option :size,        validate: true
    option :target,      validate: { inclusion: LINK_TARGETS }
    option :text
    option :type,
      default:  'button',
      validate: { inclusion: Set.new(%w[button link form reset submit]) }
    option :url, validate: true

    # Generates the button.
    #
    # @return [ActiveSupport::SafeBuffer] the rendered button.
    def call
      case type
      when 'button', 'reset', 'submit'
        render_button(type:)
      when 'link'
        render_link
      else
        render_form
      end
    end

    # @return [true, false] if true, configures the form to perform a remote
    #   request. i.e. an XHR or Turbo request.
    def remote?
      !!options.fetch(:remote, configuration.remote_forms)
    end

    private

    def button_attributes
      attributes = {
        class:    button_class,
        disabled: disabled?
      }

      return attributes if type == 'form'

      attributes.merge(data:)
    end

    def button_class
      class_names(
        bulma_class_names(
          'button',
          color    ? "is-#{color}" : nil,
          loading? ? 'is-loading'  : nil,
          size     ? "is-#{size}"  : nil
        ),
        class_name
      )
    end

    def form_attributes
      {
        class:  bulma_class_names('is-inline-block'),
        data:,
        method: http_method,
        local:  !remote?,
        url:
      }
    end

    def render_button(type:)
      content_tag('button', **button_attributes, type:) do
        render_label
      end
    end

    def render_form
      form_with(**form_attributes) { render_button(type: 'submit') }
    end

    def render_icon
      render components::Icon.build(icon:)
    end

    def render_label
      if icon && text
        buffer = ActiveSupport::SafeBuffer.new
        buffer << render_icon
        buffer << "\n"
        buffer << content_tag('span') { text }
      elsif icon
        render_icon
      else
        text
      end
    end

    def render_link
      attributes = { class: button_class }
      attributes[:href]   = url          if url
      attributes[:target] = "_#{target}" if target

      content_tag('a', **attributes) { render_label }
    end

    def validate_url(value, as: 'url') # rubocop:disable Metrics/MethodLength
      return unless type == 'form' || type == 'link' # rubocop:disable Style/MultipleComparison

      if value.blank?
        return tools.assertions.error_message_for(
          'sleeping_king_studios.tools.assertions.presence',
          as:
        )
      end

      return if url.is_a?(String)

      tools.assertions.error_message_for(
        'sleeping_king_studios.tools.assertions.instance_of',
        as:,
        expected: String
      )
    end
  end
end
