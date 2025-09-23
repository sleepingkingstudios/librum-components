# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Base, type: :component do
  describe '::MissingComponent' do
    let(:described_class)   { super()::MissingComponent }
    let(:component_options) { { display:, name: } }
    let(:display)           { 'block' }
    let(:name)              { 'Buttons::LaunchRocket' }

    describe '.new' do
      it 'should define the constructor' do
        expect(described_class)
          .to be_constructible
          .with(0).arguments
          .and_keywords(:display, :name)
          .and_any_keywords
      end
    end

    describe '#call' do
      let(:snapshot) do
        <<~HTML
          <div style="color: #f00;">
            Missing Component #{name}
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with display: "inline"' do
        let(:display) { 'inline' }
        let(:snapshot) do
          <<~HTML
            <span style="color: #f00;">
              Missing Component #{name}
            </span>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end

    describe '#display' do
      include_examples 'should define reader', :display, -> { display }
    end

    describe '#name' do
      include_examples 'should define reader', :name, -> { name }
    end
  end

  include_deferred 'should be a view component'

  include_deferred 'should be an abstract view component', described_class

  describe '#build_component' do
    let(:names)   { %w[Buttons::LaunchRocket] }
    let(:options) { {} }
    let(:built)   { build_component }

    define_method :build_component do
      component.build_component(*names, **options)
    end

    it 'should define the method' do
      expect(component)
        .to respond_to(:build_component)
        .with(1).argument
        .and_keywords(:_display, :_scope)
        .and_any_keywords
    end

    include_deferred 'should return a missing component',
      'Buttons::LaunchRocket'

    describe 'with display: "inline"' do
      let(:options) { super().merge(_display: 'inline') }

      include_deferred 'should return a missing component',
        'Buttons::LaunchRocket',
        display: 'inline'
    end

    describe 'with scope: value' do
      let(:options) { super().merge(_scope: Spec::Custom) }

      example_constant 'Spec::Custom', Module.new

      include_deferred 'should return a missing component',
        'Buttons::LaunchRocket'

      context 'when the scope defines a missing component' do
        let(:expected_options) { { display: 'block', name: names.first } }

        example_class 'Spec::Custom::MissingComponent',
          ViewComponent::Base \
        do |klass|
          klass.define_method :initialize do |**options|
            @options = options
          end

          klass.attr_reader :options
        end

        it { expect(built).to be_a Spec::Custom::MissingComponent }

        it { expect(built.options).to be == expected_options }
      end

      context 'when the scope defines the requested component' do
        example_class 'Spec::Custom::Buttons::LaunchRocket',
          ViewComponent::Base \
        do |klass|
          klass.define_method :initialize do |**options|
            @options = options
          end

          klass.attr_reader :options
        end

        it { expect(built).to be_a Spec::Custom::Buttons::LaunchRocket }

        it { expect(built.options).to be == {} }

        describe 'with options' do
          let(:options) { super().merge(color: 'red', size: 'big') }

          it { expect(built.options).to be == { color: 'red', size: 'big' } }
        end
      end

      context 'when the components define a missing component' do
        let(:expected_options) { { display: 'block', name: names.first } }

        before(:example) do
          stub_provider(
            Librum::Components.provider,
            :components,
            Spec::Components
          )
        end

        example_class 'Spec::Components::MissingComponent',
          ViewComponent::Base \
        do |klass|
          klass.define_method :initialize do |**options|
            @options = options
          end

          klass.attr_reader :options
        end

        it { expect(built).to be_a Spec::Components::MissingComponent }

        it { expect(built.options).to be == expected_options }
      end

      describe 'with multiple names' do
        let(:names) do
          %w[
            Buttons::BuildRocket
            Buttons::LaunchRocket
            Buttons::RecoverRocket
          ]
        end

        example_class 'Spec::Custom::Buttons::LaunchRocket',
          ViewComponent::Base \
        do |klass|
          klass.define_method :initialize do |**options|
            @options = options
          end

          klass.attr_reader :options
        end

        it { expect(built).to be_a Spec::Custom::Buttons::LaunchRocket }

        it { expect(built.options).to be == {} }

        describe 'with options' do
          let(:options) { super().merge(color: 'red', size: 'big') }

          it { expect(built.options).to be == { color: 'red', size: 'big' } }
        end
      end
    end

    context 'when the components are defined' do
      before(:example) do
        stub_provider(
          Librum::Components.provider,
          :components,
          Spec::Components
        )
      end

      example_constant 'Spec::Components', Module.new

      include_deferred 'should return a missing component',
        'Buttons::LaunchRocket'

      context 'when the components define a missing component' do
        let(:expected_options) { { display: 'block', name: names.first } }

        example_class 'Spec::Components::MissingComponent',
          ViewComponent::Base \
        do |klass|
          klass.define_method :initialize do |**options|
            @options = options
          end

          klass.attr_reader :options
        end

        it { expect(built).to be_a Spec::Components::MissingComponent }

        it { expect(built.options).to be == expected_options }
      end

      context 'when the components define the requested component' do
        example_class 'Spec::Components::Buttons::LaunchRocket',
          ViewComponent::Base \
        do |klass|
          klass.define_method :initialize do |**options|
            @options = options
          end

          klass.attr_reader :options
        end

        it { expect(built).to be_a Spec::Components::Buttons::LaunchRocket }

        it { expect(built.options).to be == {} }

        describe 'with options' do
          let(:options) { super().merge(color: 'red', size: 'big') }

          it { expect(built.options).to be == { color: 'red', size: 'big' } }
        end
      end

      describe 'with multiple names' do
        let(:names) do
          %w[
            Buttons::BuildRocket
            Buttons::LaunchRocket
            Buttons::RecoverRocket
          ]
        end

        example_class 'Spec::Components::Buttons::LaunchRocket',
          ViewComponent::Base \
        do |klass|
          klass.define_method :initialize do |**options|
            @options = options
          end

          klass.attr_reader :options
        end

        it { expect(built).to be_a Spec::Components::Buttons::LaunchRocket }

        it { expect(built.options).to be == {} }

        describe 'with options' do
          let(:options) { super().merge(color: 'red', size: 'big') }

          it { expect(built.options).to be == { color: 'red', size: 'big' } }
        end
      end
    end
  end
end
