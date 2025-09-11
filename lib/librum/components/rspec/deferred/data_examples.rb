# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred/provider'

require 'librum/components/rspec/deferred'

module Librum::Components::RSpec::Deferred
  # Deferred examples verifying component options.
  module DataExamples
    include RSpec::SleepingKingStudios::Deferred::Provider

    deferred_examples 'should validate the data field' \
    do |field_name = 'field', required: false|
      unless required
        describe 'with nil' do
          let(:field) { nil }
          let(:as)    { defined?(super()) ? super() : field_name }
          let(:error_message) do
            "#{as} is not a Hash or Definition"
          end

          include_deferred 'should return an invalid field result'
        end

        describe 'with an empty Hash' do
          let(:field) { {} }
          let(:as)    { defined?(super()) ? super() : field_name }
          let(:error_message) do
            "#{as} is missing required property :key"
          end

          include_deferred 'should return an invalid field result'
        end
      end

      describe 'with an Object' do
        let(:field) { Object.new.freeze }
        let(:as)    { defined?(super()) ? super() : field_name }
        let(:error_message) do
          "#{as} is not a Hash or Definition"
        end

        include_deferred 'should return an invalid field result'
      end

      describe 'with a Definition' do
        let(:field) do
          Librum::Components::DataField::Definition.new(**properties)
        end

        include_deferred 'should return a valid field result'
      end

      describe 'with a Hash with extra properties' do
        let(:field) { { key: 'title', invalid: 'invalid', other: 'other' } }
        let(:as)    { defined?(super()) ? super() : field_name }
        let(:error_message) do
          "#{as} has unknown properties :invalid, :other"
        end

        include_deferred 'should return an invalid field result'
      end

      describe 'with a valid Hash' do
        let(:field) { properties }

        include_deferred 'should return a valid field result'
      end
    end

    deferred_examples 'should validate the data field list' \
    do |field_name = 'fields', required: false|
      unless required
        describe 'with nil' do
          let(:fields) { nil }
          let(:as)     { defined?(super()) ? super() : field_name }
          let(:error_message) do
            "#{as} is not an instance of Array"
          end

          include_deferred 'should return an invalid field result'
        end

        describe 'with an empty Array' do
          let(:fields) { [] }

          include_deferred 'should return a valid field result'
        end
      end

      describe 'with an Array of Definitions' do
        let(:fields) do
          [
            { key: 'title' },
            { key: 'Author', label: 'Author Name' },
            { key: 'Published?', type: :boolean }
          ]
            .map { |item| Librum::Components::DataField::Definition.new(item) }
        end

        include_deferred 'should return a valid field result'
      end

      describe 'with an Array of valid Hashes' do
        let(:fields) do
          [
            { key: 'title' },
            { key: 'Author', label: 'Author Name' },
            { key: 'Published?', type: :boolean }
          ]
        end

        include_deferred 'should return a valid field result'
      end

      describe 'with an Array with a nil value' do
        let(:fields) do
          [
            { key: 'title' },
            nil,
            { key: 'Author', label: 'Author Name' },
            { key: 'Published?', type: :boolean }
          ]
        end
        let(:as) { defined?(super()) ? super() : field_name }
        let(:error_message) do
          "#{as} item 1 is not a Hash or Definition"
        end

        include_deferred 'should return an invalid field result'
      end

      describe 'with an Array with an Object value' do
        let(:fields) do
          [
            { key: 'title' },
            Object.new.freeze,
            { key: 'Author', label: 'Author Name' },
            { key: 'Published?', type: :boolean }
          ]
        end
        let(:as) { defined?(super()) ? super() : field_name }
        let(:error_message) do
          "#{as} item 1 is not a Hash or Definition"
        end

        include_deferred 'should return an invalid field result'
      end

      describe 'with an Array with an empty value' do
        let(:fields) do
          [
            { key: 'title' },
            {},
            { key: 'Author', label: 'Author Name' },
            { key: 'Published?', type: :boolean }
          ]
        end
        let(:as) { defined?(super()) ? super() : field_name }
        let(:error_message) do
          "#{as} item 1 is missing required property :key"
        end

        include_deferred 'should return an invalid field result'
      end

      describe 'with an Array with a value with extra keys' do
        let(:fields) do
          [
            { key: 'title' },
            { key: 'slug', invalid: 'invalid', other: 'other' },
            { key: 'Author', label: 'Author Name' },
            { key: 'Published?', type: :boolean }
          ]
        end
        let(:as) { defined?(super()) ? super() : field_name }
        let(:error_message) do
          "#{as} item 1 has unknown properties :invalid, :other"
        end

        include_deferred 'should return an invalid field result'
      end

      describe 'with an Array with multiple invalid values' do
        let(:fields) do
          [
            { key: 'title' },
            nil,
            { key: 'Author', label: 'Author Name' },
            {},
            { key: 'Published?', type: :boolean },
            { key: 'slug', invalid: 'invalid', other: 'other' }
          ]
        end
        let(:as) { defined?(super()) ? super() : field_name }
        let(:error_message) do
          "#{as} item 1 is not a Hash or Definition, " \
            "#{as} item 3 is missing required property :key, " \
            "#{as} item 5 has unknown properties :invalid, :other"
        end

        include_deferred 'should return an invalid field result'
      end
    end
  end
end
