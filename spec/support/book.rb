# frozen_string_literal: true

Book = Struct.new(:id, :title, :author) do
  define_singleton_method(:columns) do
    [
      Struct.new(:name, :type).new(name: :id, type: :integer)
    ]
  end

  define_singleton_method(:primary_key) { :id }
end
