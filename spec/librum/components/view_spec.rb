# frozen_string_literal: true

require 'cuprum'
require 'cuprum/rails'

require 'librum/components'

RSpec.describe Librum::Components::View, type: :component do
  subject(:component) do
    described_class.new(**required_keywords, **component_options)
  end

  include_deferred 'should be a view'

  include_deferred 'should be an abstract view component', described_class
end
