# frozen_string_literal: true

require 'librum/components'

module Librum::Components
  # Namespace for exceptions raised by Librum::Components.
  module Errors
    autoload :AbstractComponentError,
      'librum/components/errors/abstract_component_error'
    autoload :DuplicateOptionError,
      'librum/components/errors/duplicate_option_error'
    autoload :ExistingProviderError,
      'librum/components/errors/existing_provider_error'
    autoload :InvalidComponentError,
      'librum/components/errors/invalid_component_error'
    autoload :InvalidOptionsError,
      'librum/components/errors/invalid_options_error'
  end
end
