# frozen_string_literal: true

require 'librum/components'

module Librum::Components
  # Namespace for components using the Bulma CSS Framework.
  #
  # @see https://bulma.io/
  module Bulma
    autoload :Base,    'librum/components/bulma/base'
    autoload :Icon,    'librum/components/bulma/icon'
    autoload :Label,   'librum/components/bulma/label'
    autoload :Options, 'librum/components/bulma/options'
  end
end
