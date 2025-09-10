# frozen_string_literal: true

require 'cuprum/rails/result'

require 'librum/components'

RSpec.describe Librum::Components::Views::MissingView,
  type: :component \
do
  subject(:component) do
    described_class.new(**required_keywords, **component_options)
  end

  let(:component_options) do
    {
      expected_page:,
      view_paths:
    }
  end
  let(:expected_page) { 'Books#publish' }
  let(:view_paths) do
    [
      'Components::Books::Publish',
      'Components::Resources::Publish'
    ]
  end

  include_deferred 'should be a view'

  include_deferred 'should define component option',
    :expected_page,
    value: 'Messages#send'

  include_deferred 'should define component option',
    :view_paths,
    value: %w[Components::Messages::Send]

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

        <pre>{"action_name" =&gt; "publish", "controller_name" =&gt; "books", "member_action" =&gt; false}</pre>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with a result with properties' do
      let(:result) do
        Cuprum::Rails::Result.new(
          value:    { ok: false },
          status:   :failure,
          error:    Cuprum::Error.new(message: 'Something went wrong'),
          metadata: result_metadata.merge('error_code' => '15151')
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

          <pre>{"action_name" =&gt; "publish", "controller_name" =&gt; "books", "member_action" =&gt; false, "error_code" =&gt; "15151"}</pre>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end
end
