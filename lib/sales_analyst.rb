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
    number_of_items.reduce(:+).to_f/number_of_items.length
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
end
