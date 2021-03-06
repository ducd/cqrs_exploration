# frozen_string_literal: true

module Product
  module Repositories
    module Read
      class OrderRepo < ROM::Repository[:orders]
        def by_uuid(uuid)
          orders.combine(:order_lines).where(uuid: uuid).one!
        end
      end
    end
  end
end
