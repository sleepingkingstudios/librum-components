# frozen_string_literal: true

require 'librum/components'

module Librum::Components::Bulma::Layouts
  # Renders the footer for a page component.
  class Page::Footer < Librum::Components::Bulma::Base
    option :copyright
    option :max_width, required: true
    option :tagline

    # @return [true, false] true if the copyright or tagline is present;
    #   otherwise false.
    def render?
      present?(copyright) || present?(tagline)
    end

    private

    def build_copyright
      Librum::Components::Bulma::Layouts::Page::Footer::Copyright
        .build(copyright)
    end

    def container_class_name
      class_names('container', "is-max-#{max_width}")
    end

    def render_tagline?
      tagline.present?
    end
  end
end
