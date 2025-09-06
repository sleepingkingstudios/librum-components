# frozen_string_literal: true

require 'librum/components/errors'

module Librum::Components::Errors
  # Exception raised when assigning a value to a provider that already exists.
  class ExistingProviderError < StandardError; end
end
