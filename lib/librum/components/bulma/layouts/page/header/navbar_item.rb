# frozen_string_literal: true

require 'librum/components'

module Librum::Components::Bulma::Layouts
  # Renders a navigation item for the default page header.
  class Page::Header::NavbarItem < Librum::Components::Bulma::Base
    option :label, required: true
    option :url,   required: true

    private

    def link_class_name
      bulma_class_names('navbar-item')
    end
  end
end
