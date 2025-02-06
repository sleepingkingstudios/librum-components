# frozen_string_literal: true

require 'forwardable'

require 'byebug'
require 'sleeping_king_studios/tools'

module Plumbum
  class DependencyNotFoundError < StandardError; end

  module Consumer
    extend SleepingKingStudios::Tools::Toolbox::Mixin

    module ClassMethods
      def dependency(key, delegate: [])
        validate_key(key)

        key = key.to_s

        dependencies[key] = {}

        self::Dependencies.define_method(key) { get_plumbum_dependency(key) }

        delegate.each do |method_name|
          self::Dependencies.define_method(method_name) do
            get_plumbum_dependency(key).public_send(method_name)
          end
        end
      end

      def dependencies
        @dependencies ||= {}
      end

      private

      def tools
        SleepingKingStudios::Tools::Toolbelt.instance
      end

      def validate_key(key)
        tools.assertions.validate_name(key, as: 'key')
      end
    end

    class << self
      def included(other)
        super

        return if other.const_defined?(:Dependencies, false)

        other.const_set(:Dependencies, Module.new)
        other.include(other::Dependencies)
      end
    end

    def get_plumbum_dependency(key)
      plumbum_providers.reverse_each do |provider|
        return provider.read(key) if provider.key?(key)
      end

      raise DependencyNotFoundError, "Missing dependency #{key.to_s.inspect}"
    end

    def register_plumbum_provider(provider)
      plumbum_providers << provider
    end

    private

    def initialize_plumbum_providers
      []
    end

    def plumbum_providers
      @plumbum_providers ||= initialize_plumbum_providers
    end
  end

  module Consumers
    module Parameters
      class << self
        def bisect_keys(hsh, expected_keys)
          matching     = {}
          non_matching = {}

          hsh.each do |key, value|
            if expected_keys.include?(key.to_s)
              matching[key] = value
            else
              non_matching[key] = value
            end
          end

          [matching, non_matching]
        end
      end

      def initialize(*, **keywords, &)
        parameter_values, keywords =
          Plumbum::Consumers::Parameters.bisect_keys(
            keywords,
            Set.new(self.class.dependencies.keys.map)
          )

        super

        @parameters_provider = Plumbum::Provider.new(**parameter_values)
      end

      private

      def initialize_plumbum_providers
        super << @parameters_provider
      end
    end

    module Singleton
      private

      def initialize_plumbum_providers
        self
          .class
          .ancestors
          .select { |ancestor| ancestor.is_a?(SingletonProvider) }
          .reduce(super) { |ary, provider| ary << provider }
      end
    end
  end

  class Provider
    def initialize(**values)
      @values = tools.hash_tools.convert_keys_to_strings(values)
    end

    def [](key)
      validate_key(key)

      values[key.to_s]
    end
    alias get []
    alias read []

    def key?(key)
      validate_key(key)

      values.key?(key.to_s)
    end
    alias has? key?

    private

    attr_reader :values

    def tools
      SleepingKingStudios::Tools::Toolbelt.instance
    end

    def validate_key(key)
      tools.assertions.validate_name(key, as: 'key')
    end
  end

  class SingletonProvider < Module
    extend Forwardable

    def initialize(**values)
      super()

      @provider = Plumbum::Provider.new(**values)
    end

    def_delegators :@provider,
      :[],
      :get,
      :has?,
      :key?,
      :read

    attr_reader :provider

    def included(other)
      super

      return unless other < Consumer
      return if other < Consumers::Singleton

      other.include(Consumers::Singleton)
    end
  end
end

################################################################################
#                                                                              #
################################################################################

Application = Data.define(:launch_site)
Mission     = Data.define(:name, :launch_site, :rocket)
Rocket      = Data.define(:name)

ApplicationProvider = Plumbum::SingletonProvider.new(
  application: Application.new(launch_site: 'KSC')
)

class RocketryService
  include Plumbum::Consumer
  include Plumbum::Consumers::Singleton
  include Plumbum::Consumers::Parameters
  include ApplicationProvider

  dependency :application, delegate: %i[launch_site]

  def launch(rocket)
    Mission.new(
      name:        "#{rocket.name} 1",
      launch_site:,
      rocket:
    )
  end
end

################################################################################
#                                                                              #
################################################################################

RSpec.describe RocketryService do # rubocop:disable RSpec/SpecFilePathFormat
  subject(:service) { described_class.new(**options) }

  let(:application) { ApplicationProvider.get(:application) }
  let(:options)     { {} }

  describe '#launch' do
    let(:rocket) { Rocket.new(name: 'Cerberus') }

    it 'should launch the mission' do
      expect(service.launch(rocket)).to be_a(Mission).and have_attributes(
        launch_site: application.launch_site,
        name:        'Cerberus 1',
        rocket:
      )
    end
  end

  describe '#launch_site' do
    it { expect(service.launch_site).to be == application.launch_site }

    context 'with a test application' do
      let(:test_application) { Application.new(launch_site: 'Baikerbanur') }
      let(:options)          { super().merge(application: test_application) }

      it { expect(service.launch_site).to be == test_application.launch_site }
    end
  end
end
