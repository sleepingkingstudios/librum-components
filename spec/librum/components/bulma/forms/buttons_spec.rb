# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Bulma::Forms::Buttons,
  framework: :bulma,
  type:      :component \
do
  include_deferred 'should be a view component',
    allow_extra_options: true

  include_deferred 'should define component option',
    :alignment,
    default: 'left',
    value:   'center'

  include_deferred 'should define component option',
    :cancel_options,
    default: {},
    value:   { color: 'red' }

  include_deferred 'should define component option',
    :cancel_url,
    value: '/rockets'

  include_deferred 'should define component option', :class_name

  describe '.new' do
    include_deferred 'should validate the inclusion of option',
      :alignment,
      expected: %w[left center right]

    include_deferred 'should validate the type of option',
      :cancel_options,
      allow_nil: true,
      expected:  Hash

    include_deferred 'should validate the type of option',
      :cancel_url,
      allow_nil: true,
      expected:  String

    include_deferred 'should validate the class_name option'
  end

  describe '#call' do
    let(:snapshot) do
      <<~HTML
        <div class="field is-grouped">
          <p class="control">
            <button class="button is-link" type="submit">
              Submit
            </button>
          </p>
        </div>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with alignment: value' do
      let(:component_options) { super().merge(alignment: 'center') }
      let(:snapshot) do
        <<~HTML
          <div class="field is-grouped is-grouped-center">
            <p class="control">
              <button class="button is-link" type="submit">
                Submit
              </button>
            </p>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with cancel_url: value' do
      let(:cancel_url)        { '/rockets' }
      let(:component_options) { super().merge(cancel_url:) }
      let(:snapshot) do
        <<~HTML
          <div class="field is-grouped">
            <p class="control">
              <button class="button is-link" type="submit">
                Submit
              </button>
            </p>

            <p class="control">
              <a class="button" href="/rockets">
                Cancel
              </a>
            </p>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with cancel_options: value' do
        let(:cancel_options) do
          {
            color: 'warning',
            text:  'Go Back'
          }
        end
        let(:component_options) { super().merge(cancel_options:) }
        let(:snapshot) do
          <<~HTML
            <div class="field is-grouped">
              <p class="control">
                <button class="button is-link" type="submit">
                  Submit
                </button>
              </p>

              <p class="control">
                <a class="button is-warning" href="/rockets">
                  Go Back
                </a>
              </p>
            </div>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end

      describe 'with multiple options' do
        let(:cancel_options) do
          {
            color: 'warning',
            text:  'Go Back'
          }
        end
        let(:component_options) do
          super().merge(
            alignment:      'center',
            color:          'danger',
            text:           'Launch Rocket',
            cancel_options:
          )
        end
        let(:snapshot) do
          <<~HTML
            <div class="field is-grouped is-grouped-center">
              <p class="control">
                <button class="button is-danger" type="submit">
                  Launch Rocket
                </button>
              </p>

              <p class="control">
                <a class="button is-warning" href="/rockets">
                  Go Back
                </a>
              </p>
            </div>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end

    describe 'with class_name: value' do
      let(:component_options) { super().merge(class_name: 'custom-class') }
      let(:snapshot) do
        <<~HTML
          <div class="field is-grouped custom-class">
            <p class="control">
              <button class="button is-link" type="submit">
                Submit
              </button>
            </p>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with multiple options' do
      let(:component_options) do
        super().merge(
          alignment: 'center',
          color:     'danger',
          text:      'Launch Rocket'
        )
      end
      let(:snapshot) do
        <<~HTML
          <div class="field is-grouped is-grouped-center">
            <p class="control">
              <button class="button is-danger" type="submit">
                Launch Rocket
              </button>
            </p>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end
end
