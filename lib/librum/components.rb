# frozen_string_literal: true

require 'plumbum'

require 'librum/components/version'

# A Ruby application toolkit.
module Librum
  # Component library for Librum applications.
  module Components
    autoload :Base,          'librum/components/base'
    autoload :Colors,        'librum/components/colors'
    autoload :Configuration, 'librum/components/configuration'
    autoload :Empty,         'librum/components/empty'
    autoload :Icon,          'librum/components/icon'
    autoload :Icons,         'librum/components/icons'
    autoload :Option,        'librum/components/option'
    autoload :Options,       'librum/components/options'

    # Provider for injecting options into components.
    Provider = Plumbum::ManyProvider.new(
      write_once: true,
      values:     {
        components:    Plumbum::UNDEFINED,
        configuration: Plumbum::UNDEFINED
      }
    )

    # @return [String] the current version of the gem.
    def self.version
      VERSION
    end
  end
end
