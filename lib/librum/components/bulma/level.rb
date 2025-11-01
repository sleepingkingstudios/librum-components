# frozen_string_literal: true

module Librum::Components::Bulma
  # Layout component for aligning content horizontally.
  #
  # @see https://bulma.io/documentation/layout/level/
  class Level < Librum::Components::Bulma::Base
    include Librum::Components::Options::ClassName

    option :left_items,
      default:  [],
      validate: :level_items
    option :right_items,
      default:  [],
      validate: :level_items

    # @return [true, false] true if the level has any items; otherwise false.
    def render?
      left_items.present? || right_items.present?
    end

    private

    def level_class_name
      class_names(
        bulma_class_names('level'),
        class_name
      )
    end

    def render_item(item)
      return item if safe_buffer?(item)

      return render(item) if item.is_a?(::ViewComponent::Base)

      strip_tags(item)
    end

    def validate_level_items(value, as:)
      unless value.is_a?(Array)
        return error_message_for('instance_of', as:, expected: Array)
      end

      value
        .each
        .with_index
        .map { |item, index| validate_renderable(item, as: "#{as} #{index}") }
        .compact
        .join(', ')
    end
  end
end
