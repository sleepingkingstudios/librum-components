# frozen_string_literal: true

require 'librum/components/version'

# A Ruby application toolkit.
module Librum
  # Component library for Librum applications.
  module Components
    # @return [String] the current version of the gem.
    def self.version
      VERSION
    end
  end
end
