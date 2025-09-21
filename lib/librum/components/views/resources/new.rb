# frozen_string_literal: true

module Librum::Components::Views::Resources
  # Generic view for displaying a resource New action.
  class New < Librum::Components::Views::ResourceView
    private

    def form_component
      resource_component(:CreateForm, :Form)
    end

    def heading_text
      "Create #{resource_name.titleize}"
    end

    def render_content
      return render_form if form_component

      component = components::MissingComponent.new(
        name: "#{resource.plural_name.titleize}::Form"
      )

      render(component)
    end

    def render_form
      component = form_component.new(
        data:     resource_data,
        result:,
        resource:,
        routes:
      )

      render(component)
    end

    def resource_name
      resource.singular_name
    end
  end
end
