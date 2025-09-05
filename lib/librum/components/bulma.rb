# frozen_string_literal: true

require 'librum/components'

module Librum::Components
  # Namespace for components using the Bulma CSS Framework.
  #
  # @see https://bulma.io/
  module Bulma
    autoload :Base,          'librum/components/bulma/base'
    autoload :Box,           'librum/components/bulma/box'
    autoload :Configuration, 'librum/components/bulma/configuration'
    autoload :Heading,       'librum/components/bulma/heading'
    autoload :Icon,          'librum/components/bulma/icon'
    autoload :Label,         'librum/components/bulma/label'
    autoload :Layouts,       'librum/components/bulma/layouts'
    autoload :Link,          'librum/components/bulma/link'
    autoload :Options,       'librum/components/bulma/options'
  end
end
