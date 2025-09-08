# frozen_string_literal: true

module Librum::Components::Bulma::Views
  # View rendered when the expected view is not defined.
  class MissingView < Librum::Components::View
    option :action_name,     validate: String
    option :controller_name, validate: String
    option :expected_page,   validate: String
    option :view_paths,      validate: { array: String }

    def action_name
      options[:action_name]
    end

    def controller_name
      options[:controller_name]
    end

    private

    def pretty_inspect(value)
      return nil if value.nil?

      return value.pretty_inspect if value.respond_to?(:pretty_inspect)

      value.inspect
    end
  end
end
