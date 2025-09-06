# frozen_string_literal: true

require 'librum/components/errors'

module Librum::Components::Errors
  # Exception raised when building a component with invalid parameters.
  class InvalidComponentError < StandardError; end
end
