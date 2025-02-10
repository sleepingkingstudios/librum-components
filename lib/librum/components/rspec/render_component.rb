# frozen_string_literal: true

require 'action_controller'

require 'librum/components/rspec'

module Librum::Components::RSpec
  # Test helper for rendering a ViewComponent instance to a String.
  module RenderComponent
    VIEW_CONTEXT = ActionController::Base.new.view_context.freeze
    private_constant :VIEW_CONTEXT

    # Renders a component to a string.
    #
    # @param component [ViewComponent::Base] the component to render.
    #
    # @return [String] the string representation of the component.
    def render_component(component)
      validate_component!(component)

      VIEW_CONTEXT.render(component)
    end

    # Renders a component to a Nokogiri document fragment.
    #
    # @param component [ViewComponent::Base] the component to render.
    #
    # @return [Nokogiri::HTML::DocumentFragment] the parsed document fragment.
    def render_document(component)
      Nokogiri::HTML5.fragment(render_component(component))
    end

    private

    def validate_component!(component)
      return if component.is_a?(ViewComponent::Base)

      message =
        "expected an instance of ViewComponent::Base, got #{component.inspect}"

      raise ArgumentError,
        message,
        caller(1..)
    end
  end
end
