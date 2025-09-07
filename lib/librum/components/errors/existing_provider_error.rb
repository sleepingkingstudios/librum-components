# frozen_string_literal: true

module Librum::Components::Errors
  # Exception raised when assigning a value to a provider that already exists.
  class ExistingProviderError < StandardError; end
end
