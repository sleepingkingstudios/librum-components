# frozen_string_literal: true

require 'librum/components'

module Librum::Components::Bulma::Resources
  # Utility component rendering the actions for a table component.
  class TableActions < Librum::Components::Bulma::Base
    allow_extra_options

    option :data
    option :resource, required: true
    option :routes,   required: true

    # @return [true, false] if true, configures the form to perform a remote
    #   request. i.e. an XHR or Turbo request.
    def remote?
      if resource.respond_to?(:remote_forms)
        resource.remote_forms.then { |value| return value unless value.nil? }
      end

      configuration.remote_forms
    end

    private

    def actions
      actions = []

      actions << build_show_action    if resource.actions.include?('show')
      actions << build_update_action  if resource.actions.include?('edit')
      actions << build_destroy_action if resource.actions.include?('destroy')

      actions
    end

    def build_destroy_action
      components::Resources::DestroyButton.new(
        class_name:      bulma_class_names('px-1'),
        confirm_message: destroy_message,
        icon:            nil,
        link:            true,
        outline:         false,
        text:            'Destroy',
        url:             routes.destroy_path(resource_id)
      )
    end

    def build_show_action
      components::Button.new(
        class_name: bulma_class_names('px-1'),
        color:      'info',
        link:       true,
        text:       'Show',
        type:       'link',
        url:        routes.show_path(resource_id)
      )
    end

    def build_update_action
      components::Button.new(
        class_name: bulma_class_names('px-1'),
        color:      'warning',
        link:       true,
        text:       'Update',
        type:       'link',
        url:        routes.edit_path(resource_id)
      )
    end

    def destroy_message
      title = resource_title || data&.[]('id')

      "This will permanently delete #{resource.singular_name} #{title}.\n\n" \
        'Confirm deletion?'
    end

    def resource_id
      return @resource_id if @resource_id

      @resource_id = data['slug'] || data['id']
    end

    def resource_title
      return unless resource.respond_to?(:title_attribute)

      attribute = resource.title_attribute

      data&.[](attribute)
    end
  end
end
