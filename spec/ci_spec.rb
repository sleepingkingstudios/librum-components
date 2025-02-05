# frozen_string_literal: true

require 'byebug'
require 'sleeping_king_studios/tools'

module Plumbum
  class DependencyNotFoundError < StandardError; end

  module Consumer
    extend SleepingKingStudios::Tools::Toolbox::Mixin

    module ClassMethods
      def dependency(key)
        validate_key(key)

        define_method(key) { get_plumbum_dependency(key) }
      end

      private

      def tools
        SleepingKingStudios::Tools::Toolbelt.instance
      end

      def validate_key(key)
        tools.assertions.validate_name(key, as: 'key')
      end
    end

    def get_plumbum_dependency(key)
      plumbum_providers.each do |provider|
        return provider.read(key) if provider.key?(key)
      end

      raise DependencyNotFoundError, "Missing dependency #{key.to_s.inspect}"
    end

    def register_plumbum_provider(provider)
      plumbum_providers << provider
    end

    private

    def plumbum_providers
      @plumbum_providers ||= []
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
end

################################################################################
#                                                                              #
################################################################################

Mission = Struct.new(:name, :launch_site, :rocket)

Rocket = Struct.new(:name)

class RocketryService
  include Plumbum::Consumer

  dependency :launch_site

  def launch(rocket)
    Mission.new("#{rocket.name} 1", launch_site, rocket)
  end
end

################################################################################
#                                                                              #
################################################################################

RSpec.describe RocketryService do # rubocop:disable RSpec/SpecFilePathFormat
  subject(:service) { described_class.new }

  let(:values)   { { launch_site: 'KSC' } }
  let(:provider) { Plumbum::Provider.new(**values) }

  before(:example) do
    service.register_plumbum_provider(provider)
  end

  describe '#launch' do
    let(:rocket) { Rocket.new(name: 'Cerberus') }

    it 'should launch the mission' do
      expect(service.launch(rocket)).to be_a(Mission).and have_attributes(
        launch_site: 'KSC',
        name:        'Cerberus 1',
        rocket:
      )
    end
  end

  describe '#launch_site' do
    it { expect(service.launch_site).to be 'KSC' }
  end
end
