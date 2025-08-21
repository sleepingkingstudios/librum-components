# frozen_string_literal: true

require 'librum/components'

module Librum::Components
  # Initializer for configuring the components in a Rails application.
  class Railtie < Rails::Railtie
    initializer 'librum-components.append_assets_path', group: :all do |app|
      app.config.assets.paths << Librum::Components.javascript_path
      app.config.assets.paths << Librum::Components.stylesheets_path
    end

    initializer 'librum-components.importmap', before: 'importmap' do |app|
      app.config.importmap.cache_sweepers <<
        Librum::Components.javascript_path
    end
  end
end
