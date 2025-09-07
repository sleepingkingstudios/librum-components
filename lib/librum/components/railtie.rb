# frozen_string_literal: true

require 'librum/components'

module Librum::Components
  # Initializer for configuring the components in a Rails application.
  class Railtie < Rails::Railtie
    # :nocov:
    class Reloader
      def initialize(file_watcher)
        @file_watcher = file_watcher
      end

      def updated?
        @file_watcher.execute_if_updated
      end
    end

    initializer 'librum-components.append_assets_path', group: :all do |app|
      app.config.assets.paths << Librum::Components.javascript_path
      app.config.assets.paths << Librum::Components.stylesheets_path
    end

    initializer 'librum-components.enable_reloading' do
      next unless Rails.application.config.enable_reloading

      tag          = 'Librum-components'
      loader_path  = Pathname.new(Librum::Components.root_path).glob('**/*')
      loader       =
        Zeitwerk::Registry.loaders.each.find { |loader| loader.tag = tag }
      file_watcher =
        ActiveSupport::FileUpdateChecker.new(loader_path) { loader.reload }

      Rails.application.reloaders << Reloader.new(file_watcher)
    end

    initializer 'librum-components.importmap', before: 'importmap' do |app|
      app.config.importmap.cache_sweepers <<
        Librum::Components.javascript_path
    end
    # :nocov:
  end
end
