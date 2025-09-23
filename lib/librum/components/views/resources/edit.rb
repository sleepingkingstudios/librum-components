# frozen_string_literal: true

module Librum::Components::Views::Resources
  # Generic view for displaying a resource New action.
  class Edit < Librum::Components::Views::ResourceView
    private

    def heading_text
      "Update #{resource_name.titleize}"
    end

    def render_content # rubocop:disable Metrics/MethodLength
      component = build_component(
        'UpdateForm',
        'Form',
        action:   'edit',
        data:     resource_data,
        result:,
        resource:,
        routes:,
        _scope:   resource_components
      )

      render(component)
    end

    def resource_name
      resource.singular_name
    end
  end
end
