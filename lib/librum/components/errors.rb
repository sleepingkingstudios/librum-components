# frozen_string_literal: true

require 'librum/components'

module Librum::Components
  # Namespace for exceptions raised by Librum::Components.
  module Errors
    autoload :AbstractComponentError,
      'librum/components/errors/abstract_component_error'
    autoload :InvalidComponentError,
      'librum/components/errors/invalid_component_error'
  end
end
