# frozen_string_literal: true

module Librum::Components::Views
  # Abstract view for displaying a resource action.
  class ResourceView < Librum::Components::View
    class << self
      # @return [true, false] true if the component class is an abstract class;
      #   otherwise returns false.
      def abstract?
        self == Librum::Components::View
      end
    end

    # @overload initialize(result, resource: nil, **options)
    #   @param result [Cuprum::Result] the result returned by the controller
    #     action.
    #   @param request [Cuprum::Rails::Request] the request handled by the
    #     controller.
    #   @param resource [Cuprum::Rails::Resource] the resource for the
    #     controller.
    #   @param options [Hash] additional options for the view.
    def initialize(request:, resource:, result:, **) # rubocop:disable Lint/UselessMethodDefinition
      super
    end

    # The routes for the resource, with path wildcards pre-filled.
    #
    # @return [Cuprum::Rails::Routes]
    def routes
      @routes ||=
        resource
        .routes
        &.with_wildcards(request.path_parameters.stringify_keys)
    end

    private

    def heading_actions
      []
    end

    def heading_text
      "#{action_name.to_s.titleize} #{resource_name.titleize}"
    end

    def render_after_content = nil

    def render_before_content = nil

    def render_content = content

    def render_heading
      component = components::Heading.new(
        actions: heading_actions,
        level:   1,
        text:    heading_text
      )

      render(component)
    end

    def resource_components
      return Librum::Components::Empty unless resource.respond_to?(:components)

      resource.components
    end

    def resource_data
      result.value&.[](resource_name)
    end

    def resource_id
      resource_data&.then { |data| data['slug'] || data['id'] }
    end

    def resource_name
      return resource.singular_name if resource.singular? || member_action?

      resource.plural_name
    end
  end
end
