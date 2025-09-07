# frozen_string_literal: true

require 'librum/components'

module Librum::Components::Bulma::Layouts
  # Flexible layout component used to render a full content page.
  class Page < Librum::Components::Bulma::Base
    option :brand
    option :color, validate: true
    option :copyright
    option :max_width, default: 'desktop'
    option :navigation
    option :tagline
    option :title

    # @return [true, false] if true, indicates that the component represents a
    #   full-page layout. Defaults to true.
    def is_layout? = true # rubocop:disable Naming/PredicatePrefix

    private

    def build_footer
      Librum::Components::Bulma::Layouts::Page::Footer.new(
        copyright:,
        max_width:,
        tagline:
      )
    end

    def build_header
      Librum::Components::Bulma::Layouts::Page::Header.new(
        brand:,
        color:,
        max_width:,
        navigation:,
        title:
      )
    end

    def container_class_name
      class_names(
        'container',
        'content',
        "is-max-#{max_width}"
      )
    end
  end
end
