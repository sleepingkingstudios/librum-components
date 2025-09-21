# frozen_string_literal: true

module Librum::Components::Bulma::Forms
  # Helper component that renders the action buttons for a form.
  #
  # @see https://bulma.io/documentation/form/general/#complete-form-example
  class Buttons < Librum::Components::Bulma::Base
    allow_extra_options

    option :alignment,
      default:  'left',
      validate: { inclusion: %w[left center right] }
    option :cancel_options, default:  {}, validate: Hash
    option :cancel_url,     validate: String

    private

    def control_class_name
      bulma_class_names('control')
    end

    def field_class_name
      bulma_class_names(
        'field',
        'is-grouped',
        alignment && alignment != 'left' ? "is-grouped-#{alignment}" : nil
      )
    end

    def render_cancel_button
      component = components::Button.new(
        text: 'Cancel',
        url:  cancel_url,
        **cancel_options,
        type: 'link'
      )

      render(component)
    end

    def render_cancel_button?
      cancel_url.present?
    end

    def render_submit_button
      component = components::Button.new(
        color: 'link',
        text:  'Submit',
        **options.except(:alignment, :cancel_options, :cancel_url),
        type:  'submit'
      )

      render(component)
    end
  end
end
