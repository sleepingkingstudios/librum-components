# frozen_string_literal: true

module Librum::Components::Bulma
  # Component rendered when an expected component definition is not found.
  class MissingComponent < Librum::Components::Bulma::Base
    include Librum::Components::Options::ClassName

    option :block,
      boolean:  true,
      default:  true,
      validate: :boolean

    option :icon, default: 'bug', validate: String

    option :label

    option :message

    option :name, required: true

    # @return [String] the label to display.
    def label
      options.fetch(:label) do
        "Missing Component #{name}"
      end
    end

    private

    def block_class_name
      class_names(
        bulma_class_names('box has-text-centered'),
        class_name
      )
    end

    def inline_class_name
      class_names(
        bulma_class_names('has-text-weight-bold has-text-danger icon-text'),
        class_name
      )
    end

    def render_icon
      component = components::Icon.build(icon:)

      render(component)
    end
  end
end
