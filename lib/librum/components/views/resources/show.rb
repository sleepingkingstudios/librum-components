# frozen_string_literal: true

module Librum::Components::Views::Resources
  # Generic view for displaying a resource New action.
  class Show < Librum::Components::Views::ResourceView
    private

    def destroy_action
      build_component(
        'Resources::DestroyButton',
        text:     "Destroy #{resource.singular_name.titleize}",
        url:      routes.destroy_path(resource_id),
        _display: 'inline'
      )
    end

    def heading_actions
      return [] unless resource_data

      actions = []

      actions << update_action  if resource.actions.include?('edit')
      actions << destroy_action if resource.actions.include?('destroy')

      actions
    end

    def heading_text
      resource_title.presence || "Show #{resource_name.titleize}"
    end

    def render_content
      component = build_component(
        'Block',
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

    def resource_title
      return unless resource.respond_to?(:title_attribute)

      attribute = resource.title_attribute

      resource_data&.[](attribute)
    end

    def update_action
      {
        button: true,
        icon:   'pencil',
        text:   "Update #{resource_name.titleize}",
        type:   'link',
        url:    routes.edit_path(resource_id)
      }
    end
  end
end
