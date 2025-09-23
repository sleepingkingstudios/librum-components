# frozen_string_literal: true

module Librum::Components::Views::Resources
  # Generic view for displaying a resource New action.
  class New < Librum::Components::Views::ResourceView
    private

    def heading_text
      "Create #{resource_name.titleize}"
    end

    def render_content
      component = build_component(
        'CreateForm',
        'Form',
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
