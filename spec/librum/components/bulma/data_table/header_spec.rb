# frozen_string_literal: true

require 'librum/components'
require 'librum/components/rspec/deferred/data_examples'

RSpec.describe Librum::Components::Bulma::DataTable::Header,
  framework: :bulma,
  type:      :component \
do
  include Librum::Components::RSpec::Deferred::DataExamples

  let(:component_options) { { columns: } }
  let(:columns) do
    [
      { key: 'title' },
      { key: 'author', label: 'Author Name' },
      { key: 'published', type: :boolean },
      {
        key:   'actions',
        label: '',
        value: Librum::Components::Literal.new('<span>Actions</span>')
      }
    ]
      .map { |hsh| Librum::Components::DataField::Definition.normalize(hsh) }
  end

  include_deferred 'should be a view component',
    allow_extra_options: true

  include_deferred 'should define component option',
    :columns,
    value: [{ key: 'title' }]

  describe '.new' do
    include_deferred 'should validate the presence of option',
      :columns,
      array: true

    deferred_examples 'should return an invalid field result' do
      it 'should raise an exception' do
        expect { described_class.new(**component_options, columns: fields) }
          .to raise_error ArgumentError, error_message
      end
    end

    deferred_examples 'should return a valid field result' do
      it 'should not raise an exception' do
        expect { described_class.new(**component_options, columns: fields) }
          .not_to raise_error
      end
    end

    include_deferred 'should validate the data field list',
      :columns,
      required: true
  end

  describe '#call' do
    # Wrap contents in a table to ensure HTML fragment is valid.
    let(:rendered) { "<table>#{super()}</table>" }
    let(:snapshot) do
      <<~HTML
        <table>
          <thead>
            <tr>
              <th>Title</th>

              <th>Author Name</th>

              <th>Published</th>

              <th></th>
            </tr>
          </thead>
        </table>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }
  end
end
