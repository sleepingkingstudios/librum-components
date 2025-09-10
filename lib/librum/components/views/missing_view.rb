# frozen_string_literal: true

require 'pp'

module Librum::Components::Views
  # View rendered when the expected view is not defined.
  class MissingView < Librum::Components::View
    option :expected_page,   validate: String
    option :view_paths,      validate: { array: String }
  end
end
