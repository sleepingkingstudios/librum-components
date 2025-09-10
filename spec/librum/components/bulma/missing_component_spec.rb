# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Bulma::MissingComponent,
  framework: :bulma,
  type:      :component \
do
  let(:component_options) { { name: } }
  let(:name)              { 'ExpectedComponent' }

  include_deferred 'with configuration',
    default_icon_family: 'fa-solid',
    icon_families:       %i[fa-solid]

  include_deferred 'should be a view component'

  include_deferred 'should define component option',
    :block,
    boolean: true,
    default: true

  include_deferred 'should define component option',
    :icon,
    default: 'bug'

  include_deferred 'should define component option', :message

  include_deferred 'should define component option', :name

  describe '.new' do
    include_deferred 'should validate the type of option',
      :icon,
      expected: String

    include_deferred 'should validate the presence of option',
      :name,
      string: true
  end

  describe '#call' do
    let(:snapshot) do
      <<~HTML
        <div class="box has-text-centered">
          <span class="title is-size-5 has-text-danger icon-text">
            <span class="icon">
              <i class="fa-solid fa-#{component.icon}"></i>
            </span>

            #{component.label}
          </span>
        </div>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with block: false' do
      let(:component_options) do
        super().merge(block: false)
      end
      let(:snapshot) do
        <<~HTML
          <span class="has-text-weight-bold has-text-danger icon-text">
            <span class="icon">
              <i class="fa-solid fa-#{component.icon}"></i>
            </span>

            #{component.label}
          </span>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with class_name: value' do
        let(:component_options) do
          super().merge(class_name: 'custom-class')
        end
        let(:snapshot) do
          <<~HTML
            <span class="has-text-weight-bold has-text-danger icon-text custom-class">
              <span class="icon">
                <i class="fa-solid fa-#{component.icon}"></i>
              </span>

              #{component.label}
            </span>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end

      describe 'with icon: value' do
        let(:component_options) do
          super().merge(icon: 'radiation')
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end

      describe 'with label: value' do
        let(:component_options) do
          super().merge(label: 'Something Went Wrong')
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end

      describe 'with multiple options' do
        let(:component_options) do
          super().merge(
            class_name: 'custom-class',
            icon:       'radiation',
            label:      'Something Went Wrong'
          )
        end
        let(:snapshot) do
          <<~HTML
            <span class="has-text-weight-bold has-text-danger icon-text custom-class">
              <span class="icon">
                <i class="fa-solid fa-#{component.icon}"></i>
              </span>

              #{component.label}
            </span>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end

    describe 'with class_name: value' do
      let(:component_options) do
        super().merge(class_name: 'custom-class')
      end
      let(:snapshot) do
        <<~HTML
          <div class="box has-text-centered custom-class">
            <span class="title is-size-5 has-text-danger icon-text">
              <span class="icon">
                <i class="fa-solid fa-#{component.icon}"></i>
              </span>

              #{component.label}
            </span>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with icon: value' do
      let(:component_options) do
        super().merge(icon: 'radiation')
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with label: value' do
      let(:component_options) do
        super().merge(label: 'Something Went Wrong')
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with message: value' do
      let(:component_options) do
        super().merge(message: 'Have you tried turning off and on again?')
      end
      let(:snapshot) do
        <<~HTML
          <div class="box has-text-centered">
            <span class="title is-size-5 has-text-danger icon-text">
              <span class="icon">
                <i class="fa-solid fa-#{component.icon}"></i>
              </span>

              #{component.label}
            </span>

            <p>#{component.message}</p>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with multiple options' do
      let(:component_options) do
        super().merge(
          class_name: 'custom-class',
          icon:       'radiation',
          label:      'Something Went Wrong',
          message:    'Have you tried turning off and on again?'
        )
      end
      let(:snapshot) do
        <<~HTML
          <div class="box has-text-centered custom-class">
            <span class="title is-size-5 has-text-danger icon-text">
              <span class="icon">
                <i class="fa-solid fa-#{component.icon}"></i>
              </span>

              #{component.label}
            </span>

            <p>#{component.message}</p>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end

  describe '#label' do
    include_examples 'should define reader',
      :label,
      -> { "Missing Component #{name}" }

    context 'when initialized with label: value' do
      let(:label) { 'Something Went Wrong' }
      let(:component_options) do
        super().merge(label:)
      end

      it { expect(component.label).to be == label }
    end
  end
end
