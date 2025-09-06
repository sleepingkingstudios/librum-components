# frozen_string_literal: true

require 'librum/components/errors'

module Librum::Components::Errors
  # Exception raised when defining an option that already exists.
  class DuplicateOptionError < StandardError; end
end
