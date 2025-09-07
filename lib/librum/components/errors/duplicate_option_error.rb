# frozen_string_literal: true

module Librum::Components::Errors
  # Exception raised when defining an option that already exists.
  class DuplicateOptionError < StandardError; end
end
