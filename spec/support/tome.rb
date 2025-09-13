# frozen_string_literal: true

Tome = Struct.new(:uuid, :title, :author) do
  define_singleton_method(:columns) do
    [
      Struct.new(:name, :type).new(name: :uuid, type: :uuid)
    ]
  end

  define_singleton_method(:primary_key) { :uuid }
end
