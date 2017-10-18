# frozen_string_literal: true

module Order
  module CommandHandlers
    class ApplyDiscountCommandHandler
      M = Dry::Monads
      OrdersRepo = Infrastructure::Repositories::OrdersRepository
      DiscountsRepo = Infrastructure::Repositories::DiscountsRepository
      OrderDiscountsRepo = Infrastructure::Repositories::OrderDiscountsRepository

      class << self
        def execute(command)
          validation_result = command.validate

          return M.Left(validation_result.errors) unless validation_result.success?

          order_uuid = validation_result.output[:aggregate_uuid]
          discount = validation_result.output[:discount]

          order = OrdersRepo.find_by(uuid: order_uuid)
          order.apply_discount(discount)
          OrderDiscountsRepo.apply(order: order, discount: discount)

          M.Right(true)
        end
      end
    end
  end
end