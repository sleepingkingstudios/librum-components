# frozen_string_literal: true

require 'librum/components/bulma/page'

module Librum::Components::Bulma
  # Renders the default header for a page component.
  class Page::Header < Librum::Components::Bulma::Base
    autoload :Brand,      'librum/components/bulma/page/header/brand'
    autoload :Navbar,     'librum/components/bulma/page/header/navbar'
    autoload :NavbarItem, 'librum/components/bulma/page/header/navbar_item'

    option :brand
    option :color,     validate: true
    option :max_width, required: true
    option :navigation
    option :title

    private

    def build_brand
      return brand if brand.is_a?(ViewComponent::Base)

      Librum::Components::Bulma::Page::Header::Brand.build({
        brand:,
        title:
      })
    end

    def container_class_name
      class_names(
        'container',
        "is-max-#{max_width}"
      )
    end

    def header_class_name
      class_names(
        bulma_class_names('navbar'),
        color ? bulma_class_names("is-#{color}") : nil
      )
    end

    def render_navigation
      return nil unless present?(navigation)

      return navigation if navigation.is_a?(ViewComponent::Base)

      component =
        Librum::Components::Bulma::Page::Header::Navbar.build({ navigation: })

      render(component)
    end
  end
end
