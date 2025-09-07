# frozen_string_literal: true

require 'librum/components'

module Librum::Components::Bulma::Layouts
  # Renders the copyright notice for a page component.
  class Page::Footer::Copyright < Librum::Components::Bulma::Base
    option :holder
    option :scope
    option :year

    # @return [true, false] true if the holder and year properties are present;
    #   otherwise false.
    def render?
      return false unless present?(holder)

      return false unless present?(year)

      true
    end

    private

    def build_icon
      components::Icon.new(icon: 'copyright')
    end
  end
end
