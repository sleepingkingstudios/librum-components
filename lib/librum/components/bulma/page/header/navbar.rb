# frozen_string_literal: true

require 'librum/components/bulma/page/header'

module Librum::Components::Bulma
  # Renders the navigation bar for the default page header.
  class Page::Header::Navbar < Librum::Components::Bulma::Base
    option :navigation, validate: true

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
      component = components::Page::Header::NavbarItem.new(label:, url:)

      render(component)
    end

    def validate_navigation(navigation, as: 'navigation')
      return if navigation.nil?

      return "#{as} is not an Array" unless navigation.is_a?(Array)

      navigation.each.with_index do |item, index|
        return "#{as} item #{index} is not a Hash" unless item.is_a?(Hash)
      end

      nil
    end
  end
end
