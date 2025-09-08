# frozen_string_literal: true

require 'cuprum/rails/result'

require 'librum/components'

RSpec.describe Librum::Components::Bulma::Views::MissingView,
  type: :component \
do
  subject(:component) do
    described_class.new(**required_keywords, **component_options)
  end

  let(:result)            { Cuprum::Result.new }
  let(:required_keywords) { { result: } }
  let(:component_options) do
    {
      action_name:,
      controller_name:,
      expected_page:,
      view_paths:
    }
  end
  let(:action_name)     { 'publish' }
  let(:controller_name) { 'books' }
  let(:expected_page)   { 'Books#publish' }
  let(:view_paths) do
    [
      'Components::Books::Publish',
      'Components::Resources::Publish'
    ]
  end

  include_deferred 'should be a view component'

  include_deferred 'should define component option',
    :expected_page,
    value: 'Messages#send'

  include_deferred 'should define component option',
    :view_paths,
    value: %w[Components::Messages::Send]

  describe '#action_name' do
    it { expect(described_class.options.keys).to include 'action_name' }

    it { expect(component.action_name).to be == action_name }
  end

  describe '#call' do
    let(:snapshot) do
      <<~HTML
        <h1>Missing Books#publish</h1>

        <p>
          The expected view component for

          <code>Books#publish</code>

          was not found.
        </p>

        <p>
          The view was expected to be defined at one of the following paths:
        </p>

        <ul>
          <li>
            <code>Components::Books::Publish</code>
          </li>

          <li>
            <code>Components::Resources::Publish</code>
          </li>
        </ul>

        <p>
          The page was rendered from

          <code>books#publish</code>

          .
        </p>

        <h2>Result</h2>

        <p>
          <strong>Status</strong>
        </p>

        <pre>:success</pre>

        <p>
          <strong>Value</strong>
        </p>

        <pre>(none)</pre>

        <p>
          <strong>Error</strong>
        </p>

        <pre>(none)</pre>

        <p>
          <strong>Metadata</strong>
        </p>

        <pre>{}</pre>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with a result with properties' do
      let(:result) do
        Cuprum::Rails::Result.new(
          value:    { ok: false },
          status:   :failure,
          error:    Cuprum::Error.new(message: 'Something went wrong'),
          metadata: { error_code: '15151' }
        )
      end
      let(:snapshot) do
        <<~HTML
          <h1>Missing Books#publish</h1>

          <p>
            The expected view component for

            <code>Books#publish</code>

            was not found.
          </p>

          <p>
            The view was expected to be defined at one of the following paths:
          </p>

          <ul>
            <li>
              <code>Components::Books::Publish</code>
            </li>

            <li>
              <code>Components::Resources::Publish</code>
            </li>
          </ul>

          <p>
            The page was rendered from

            <code>books#publish</code>

            .
          </p>

          <h2>Result</h2>

          <p>
            <strong>Status</strong>
          </p>

          <pre>:failure</pre>

          <p>
            <strong>Value</strong>
          </p>

          <pre>{"ok" =&gt; false}</pre>

          <p>
            <strong>Error</strong>
          </p>

          <pre>{"data" =&gt; {}, "message" =&gt; "Something went wrong", "type" =&gt; "cuprum.error"}</pre>

          <p>
            <strong>Metadata</strong>
          </p>

          <pre>{error_code: "15151"}</pre>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end

  describe '#controller_name' do
    it { expect(described_class.options.keys).to include 'controller_name' }

    it { expect(component.controller_name).to be == controller_name }
  end
end
