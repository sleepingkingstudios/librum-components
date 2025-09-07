# frozen_string_literal: true

require 'librum/components'

module Librum::Components::Bulma::Layouts
  # Renders the navigation bar for the default page header.
  class Page::Header::Navbar < Librum::Components::Bulma::Base
    option :navigation, validate: { array: Hash }

    # @return [true, false] true if the navigation items are present; otherwise
    #   false.
    def render?
      present?(navigation)
    end

    private

    def navbar_class_name
      bulma_class_names('navbar-start', 'has-text-weight-semibold')
    end

    def navbar_data_target
      'menu'
    end

    def navigation_class_name
      bulma_class_names('navbar-menu')
    end

    def render_navbar_item(label:, url:)
      component =
        Librum::Components::Bulma::Layouts::Page::Header::NavbarItem
        .new(label:, url:)

      render(component)
    end
  end
end
