require_relative 'sales_engine'

class SalesAnalyst
  attr_accessor :sales_engine

  def initialize(sales_engine)
    @sales_engine = sales_engine
  end

  def average_items_per_merchant
    number_of_items = sales_engine.merchants.all.map do |merchant|
      merchant.items.length
    end
    (number_of_items.reduce(:+).to_f/number_of_items.length).round(2)
  end

  def average_items_per_merchant_standard_deviation
    difference = sales_engine.merchants.all.map do |merchant|
      (merchant.items.length - average_items_per_merchant) ** 2
    end

    sum = difference.reduce(:+)
    Math.sqrt(sum / (difference.length - 1)).round(2)
  end

  def merchants_with_high_item_count
    sales_engine.merchants.all.map do |merchant|
      average = average_items_per_merchant
      standard_deviation = average_items_per_merchant_standard_deviation
      one_std_dev_above_average = standard_deviation + average

      merchant if merchant.items.count > one_std_dev_above_average
    end.compact
  end

  def average_item_price_for_merchant(merchant_id)
    merchant = sales_engine.merchants.find_by_id(merchant_id)
    item_prices = merchant.items.map do |item|
      item.unit_price
    end
    item_prices.reduce(:+).to_f/item_prices.length
  end

  def average_average_price_per_merchant
    item_prices = sales_engine.merchants.all.map do |merchant|
      average_item_price_for_merchant(merchant.id)
    end
    (item_prices.reduce(:+).to_f/item_prices.length).round(2)
  end

  def average_price_of_items
    item_prices = sales_engine.items.all.map do |item|
      item.unit_price
    end
    (item_prices.reduce(:+).to_f/item_prices.length).round(2)
  end

  def average_item_price_standard_deviation
    difference = sales_engine.items.all.map do |item|
      (item.unit_price - average_price_of_items) ** 2
    end

    sum = difference.reduce(:+)
    Math.sqrt(sum / (difference.length - 1)).round(2)
  end


  def golden_items
    twice_avg_price_std_dev = average_item_price_standard_deviation * 2
    average_price = average_price_of_items
    difference = sales_engine.items.all.map do |item|
      item if item.unit_price > twice_avg_price_std_dev + average_price
    end.compact
  end
end
