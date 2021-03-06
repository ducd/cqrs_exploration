# frozen_string_literal: true

module Product
  module Events
    class ProductUpdatedEvent < Infrastructure::Event
      attribute :name, T::String
      attribute :quantity, T::Int
      attribute :price, T::Int
    end
  end
end
