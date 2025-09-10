# frozen_string_literal: true

require 'librum/components'

module Librum::Components::Bulma
  # Heading component with optional actions.
  class Heading < Librum::Components::Bulma::Base
    include Librum::Components::Bulma::Options::Typography
    include Librum::Components::Options::ClassName

    option :actions, validate: { array: :component }
    option :level,   validate: true
    option :text,    validate: { presence: true }

    private

    def build_action(action)
      return action if action.is_a?(ViewComponent::Base)

      if action[:button]
        components::Button.build(type: 'link', **action.except(:button))
      else
        components::Link.build(action)
      end
    end

    def heading_class_name
      class_names(
        bulma_class_names(
          level ? nil : 'title',
          render_actions? && level ? 'mb-0' : nil,
          !render_actions? && !level ? 'is-block mb-5 title' : nil
        ),
        typography_class,
        class_name
      )
    end

    def render_action(action)
      component = build_action(action)

      return unless component

      content_tag('div', class: bulma_class_names('level-item')) do
        render(component)
      end
    end

    def render_actions?
      actions.present?
    end

    def render_heading
      tag_name   = level ? "h#{level}" : 'span'
      class_name = heading_class_name
      attributes = class_name.present? ? { class: class_name } : {}

      content_tag(tag_name, **attributes) { text }
    end

    def validate_level(value, as: 'level')
      return if value.nil?

      return "#{as} is not an instance of Integer" unless value.is_a?(Integer)

      return if level.positive? && level < 7

      "#{as} is outside the range of 1 to 6"
    end
  end
end
