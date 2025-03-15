# frozen_string_literal: true

require 'librum/components/bulma'

module Librum::Components::Bulma
  # Simple container component.
  #
  # @see https://bulma.io/documentation/elements/box/
  class Box < Librum::Components::Bulma::Base
    include Librum::Components::Options::ClassName

    # @return [ActiveSupport::SafeBuffer] the rendered component.
    def call
      content_tag(:div, class: box_class) { content }
    end

    private

    def box_class
      class_names(
        bulma_class_names('box'),
        class_name
      )
        .presence
    end
  end
end
