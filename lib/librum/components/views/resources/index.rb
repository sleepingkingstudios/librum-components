# frozen_string_literal: true

module Librum::Components::Views::Resources
  # Generic view for displaying a resource Index action.
  class Index < Librum::Components::Views::ResourceView
    private

    def create_action
      {
        button: true,
        icon:   'plus',
        text:   "Create #{resource.singular_name.titleize}",
        type:   'link',
        url:    routes.new_path
      }
    end

    def heading_actions
      actions = []

      actions << create_action if resource.actions.include?('new')

      actions
    end

    def heading_text
      resource_name.titleize
    end

    def render_content
      return render_table if table_component

      component = components::MissingComponent.new(
        name: "#{resource.plural_name.titleize}::Table"
      )

      render(component)
    end

    def render_table
      component = table_component.new(
        data:     resource_data,
        result:,
        resource:,
        routes:
      )

      render(component)
    end

    def table_component
      resource_component(:Table)
    end
  end
end
