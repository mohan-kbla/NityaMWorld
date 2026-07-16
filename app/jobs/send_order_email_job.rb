class SendOrderEmailJob < ApplicationJob
  queue_as :default

  def perform(order_id)
    order = Order.find(order_id)
    recipient = order.user&.email || "guest@example.com"
    Rails.logger.info "[Sidekiq] Async Order Email dispatched for Order ##{order.id} to #{recipient}"
  end
end
