# frozen_string_literal: true

require 'librum/components'

module Librum::Components
  # Namespace for icon family-specific icon components.
  module Icons
    autoload :Base,        'librum/components/icons/base'
    autoload :FontAwesome, 'librum/components/icons/font_awesome'
  end
end
