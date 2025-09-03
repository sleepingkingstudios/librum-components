# frozen_string_literal: true

require 'librum/components/bulma/layouts/page/header'

module Librum::Components::Bulma::Layouts
  # Renders the brand image and text for a page header.
  class Page::Header::Brand < Librum::Components::Bulma::Base
    dependency :routes, optional: true

    option :brand, validate: true
    option :title

    # @return [true, false] true if the navbar has a brand image or title;
    #   otherwise false.
    def render?
      present?(brand) || present?(title)
    end

    private

    def build_icon
      return brand[:icon] if brand[:icon].is_a?(ViewComponent::Base)

      icon_options    = { size: '2xl' }.merge(brand.except(:color))
      wrapper_options = { color: brand[:color], icon: icon_options }.compact

      components::Icon.new(**wrapper_options)
    end

    def build_image
      alt = present?(title) ? "#{title} Home" : 'Home Page'

      content_tag(:figure, class: bulma_class_names('image', 'is-32x32')) do
        tag.img(alt:, src: brand[:image_path])
      end
    end

    def build_brand
      return if brand.nil?

      return brand if brand.is_a?(ViewComponent::Base)

      return build_icon if brand.key?(:icon)

      return build_image if brand.key?(:image_path)

      nil
    end

    def render_title
      return nil unless present?(title)

      content_tag(:span, class: bulma_class_names('title', 'is-size-4')) do
        title
      end
    end

    def render_brand
      component = build_brand

      return if component.nil?

      return render(component) if component.is_a?(ViewComponent::Base)

      component
    end

    def root_path
      routes&.root_path || '/'
    end

    def validate_brand(value, as: 'brand')
      return if value.nil?

      return if value.is_a?(Hash)

      return if value.is_a?(ViewComponent::Base)

      "#{as} is not a Hash or a Component"
    end

    def wrapper_class_name
      bulma_class_names('navbar-item')
    end
  end
end
