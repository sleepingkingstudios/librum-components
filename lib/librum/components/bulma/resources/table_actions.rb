# frozen_string_literal: true

require 'librum/components'

module Librum::Components::Bulma::Resources
  # Utility component rendering the actions for a table component.
  class TableActions < Librum::Components::Bulma::Base
    option :data
    option :resource, required: true
    option :routes,   required: true

    private

    def actions
      actions = []

      actions << build_show_action    if resource.actions.include?('show')
      actions << build_update_action  if resource.actions.include?('edit')
      actions << build_destroy_action if resource.actions.include?('destroy')

      actions
    end

    def build_destroy_action
      components::Button.new(
        class_name:  bulma_class_names(
          "has-text-#{configuration.danger_color}",
          'is-borderless is-shadowless mx-0 px-1 py-0'
        ),
        http_method: 'delete',
        text:        'Destroy',
        type:        'form',
        url:         routes.destroy_path(resource_id)
      )
    end

    def build_show_action
      components::Button.new(
        class_name: bulma_class_names(
          'has-text-info is-borderless is-shadowless mx-0 px-1 py-0'
        ),
        text:       'Show',
        type:       'link',
        url:        routes.show_path(resource_id)
      )
    end

    def build_update_action
      components::Button.new(
        class_name: bulma_class_names(
          'has-text-warning is-borderless is-shadowless mx-0 px-1 py-0'
        ),
        text:       'Update',
        type:       'link',
        url:        routes.edit_path(resource_id)
      )
    end

    def resource_id
      return @resource_id if @resource_id

      @resource_id = data['slug'] || data['id']
    end
  end
end
