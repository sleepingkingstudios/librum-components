# frozen_string_literal: true

require 'librum/components'

module Librum::Components::Bulma::Layouts
  # Flexible layout component used to render a full content page.
  class Page < Librum::Components::Bulma::Base
    option :alerts, default: []
    option :brand
    option :color, validate: true
    option :copyright
    option :max_width, default: 'desktop'
    option :navigation
    option :session
    option :session_component, validate: Class
    option :tagline
    option :title

    # @return [true, false] if true, indicates that the component represents a
    #   full-page layout. Defaults to true.
    def is_layout? = true # rubocop:disable Naming/PredicatePrefix

    private

    def build_alerts
      return if alerts.nil? || alerts.empty? # rubocop:disable Rails/Blank

      Librum::Components::Bulma::Layouts::Page::Alerts.new(alerts:)
    end

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
        session:,
        session_component:,
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

    def render_alerts
      return if alerts.nil? || alerts.empty? # rubocop:disable Rails/Blank

      render(build_alerts)
    end
  end
end
