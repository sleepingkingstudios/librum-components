# frozen_string_literal: true

require 'librum/components/bulma'

module Librum::Components::Bulma
  # Flexible layout component used to render a full content page.
  class Page < Librum::Components::Bulma::Base
    autoload :Footer, 'librum/components/bulma/page/footer'
  end
end
