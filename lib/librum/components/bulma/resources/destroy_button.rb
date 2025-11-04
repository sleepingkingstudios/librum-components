# frozen_string_literal: true

module Librum::Components::Bulma::Resources
  # Utility component for rendering the destroy button for a resource.
  class DestroyButton < Librum::Components::Bulma::Base
    include Librum::Components::Options::ClassName

    option :confirm,
      boolean: true,
      default: true
    option :confirm_message,
      default:  'Are you sure?',
      validate: String
    option :icon,
      default:  'eraser',
      validate: true
    option :link,
      boolean: true,
      default: false
    option :outline,
      boolean: true,
      default: true
    option :text,
      default:  'Destroy',
      validate: String
    option :url,
      required: true,
      validate: String

    # @return [ActiveSupport::SafeBuffer] the rendered button.
    def call
      render components::Button.new(**button_options)
    end

    private

    def button_data
      return {} unless confirm?

      {
        action:            'submit->librum-components-confirm-form#submit',
        controller:        'librum-components-confirm-form',
        librum_components: {
          confirm_form: {
            message_value: confirm_message
          }
        }
      }
    end

    def button_options # rubocop:disable Metrics/MethodLength
      {
        color:       configuration.danger_color,
        class_name:,
        data:        button_data,
        http_method: 'delete',
        icon:,
        link:        link?,
        outline:     outline?,
        text:,
        type:        'form',
        url:
      }
    end
  end
end
