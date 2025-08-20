# frozen_string_literal: true

require 'librum/components/bulma/page'

module Librum::Components::Bulma
  # Renders the footer for a page component.
  class Page::Footer < Librum::Components::Bulma::Base
    autoload :Copyright, 'librum/components/bulma/page/footer/copyright'

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
      Copyright.build(copyright)
    end

    def container_class_name
      class_names('container', "is-max-#{max_width}")
    end

    def render_tagline?
      tagline.present?
    end
  end
end
