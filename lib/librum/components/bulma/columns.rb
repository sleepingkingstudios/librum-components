# frozen_string_literal: true

module Librum::Components::Bulma
  # Component rendering a set of vertical columns.
  class Columns < Librum::Components::Bulma::Base
    option :columns, required: true, validate: {
      array: Librum::Components::Base
    }
  end
end
