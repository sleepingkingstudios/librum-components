# frozen_string_literal: true

require 'librum/components/errors'

module Librum::Components::Errors
  # Exception raised when creating a component with unrecognized option.
  class InvalidOptionsError < ArgumentError; end
end
