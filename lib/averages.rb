require_relative 'collections'

module Averages
  include Collections

  def average(collection, divisor)
    (collection / divisor.to_f).round(2)
  end

  def average_items_per_merchant
    average(all_items.count, all_merchants.count)
  end

  def average_price_of_items
    average(all_item_prices.reduce(:+), all_item_prices.length)
  end

  def average_item_price_for_merchant(merchant_id)
    merchant = sales_engine.merchants.find_by_id(merchant_id)
    # merchant = merchants_grouped_by_id[merchant_id].first
    item_prices = merchant_items_prices(merchant)

    average(item_prices.reduce(:+), item_prices.length)
  end

  def average_average_price_per_merchant
    item_prices = all_merchants_item_prices
    average(item_prices.reduce(:+), item_prices.length)
  end

  def average_invoices_per_day
    average(invoices.count, 7.0)
  end

  def average_invoices_per_merchant
    average(invoices.count, all_merchants.count)
  end
end
