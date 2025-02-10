# frozen_string_literal: true

require 'action_controller'

require 'librum/components/rspec'
require 'librum/components/rspec/utils/pretty_render'

module Librum::Components::RSpec
  # Test helper for rendering a ViewComponent instance to a String.
  module RenderComponent
    PRETTY_RENDERER = Librum::Components::RSpec::Utils::PrettyRender.new.freeze
    private_constant :PRETTY_RENDERER

    VIEW_CONTEXT = ActionController::Base.new.view_context.freeze
    private_constant :VIEW_CONTEXT

    # Generates a normalized representating of a component or fragment.
    #
    # @param component
    #   [ViewComponent::Base, Nokogiri::HTML::DocumentFragment, String] the
    #   component, fragment, or HTML string to normalize.
    #
    # @return [String] the normalized string representation.
    def pretty_render(component)
      document =
        if component.is_a?(Nokogiri::HTML::DocumentFragment)
          component
        elsif component.is_a?(String)
          Nokogiri::HTML5.fragment(component)
        else
          render_document(component)
        end

      PRETTY_RENDERER.call(document)
    end

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
