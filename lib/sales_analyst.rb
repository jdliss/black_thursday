require 'bigdecimal'
require_relative 'sales_engine'

class SalesAnalyst
  attr_accessor :sales_engine

  def initialize(sales_engine)
    @sales_engine = sales_engine
  end

  def all_merchants
    sales_engine.merchants.all
  end

  def average_items_per_merchant
    (sales_engine.items.all.count/
        sales_engine.merchants.all.count.to_f).round(2)
  end

  def finish_standard_deviation(difference)
    sum = difference.reduce(:+)
    Math.sqrt(sum / (difference.length - 1)).round(2)
  end

  def average_items_per_merchant_standard_deviation
    average_items = average_items_per_merchant

    difference = all_merchants.map do |merchant|
      (merchant.items.length - average_items) ** 2
    end

    finish_standard_deviation(difference)
  end

  def merchants_with_high_item_count
    average = average_items_per_merchant
    standard_deviation = average_items_per_merchant_standard_deviation
    one_std_dev_above_average = standard_deviation + average

    sales_engine.merchants.all.map do |merchant|
      merchant if merchant.items.count > one_std_dev_above_average
    end.compact
  end

  def average_item_price_for_merchant(merchant_id)
    merchant = sales_engine.merchants.find_by_id(merchant_id)
    item_prices = merchant.items.map do |item|
      item.unit_price
    end
    (item_prices.reduce(:+)/item_prices.length).round(2)
  end

  def average_average_price_per_merchant
    item_prices = sales_engine.merchants.all.map do |merchant|
      average_item_price_for_merchant(merchant.id)
    end
    (item_prices.reduce(:+)/item_prices.length).round(2)
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

    finish_standard_deviation(difference)
  end


  def golden_items
    twice_avg_price_std_dev = average_item_price_standard_deviation * 2
    average_price = average_price_of_items
    sales_engine.items.all.map do |item|
      item if item.unit_price > twice_avg_price_std_dev + average_price
    end.compact
  end

  def average_invoices_per_merchant
    (sales_engine.invoices.all.count/
        sales_engine.merchants.all.count.to_f).round(2)
  end

  def average_invoices_per_merchant_standard_deviation
    average_invoices = average_invoices_per_merchant

    difference = all_merchants.map do |merchant|
      (merchant.invoices.length - average_invoices) ** 2
    end

    finish_standard_deviation(difference)
  end


  def top_merchants_by_invoice_count
    average = average_invoices_per_merchant
    standard_deviation = average_invoices_per_merchant_standard_deviation
    two_std_dev_above_average = (standard_deviation * 2) + average

    sales_engine.merchants.all.map do |merchant|
      merchant if merchant.invoices.count > two_std_dev_above_average
    end.compact
  end

  def bottom_merchants_by_invoice_count
    average = average_invoices_per_merchant
    standard_deviation = average_invoices_per_merchant_standard_deviation
    two_std_dev_below_average = average - (standard_deviation * 2)

    sales_engine.merchants.all.map do |merchant|
      merchant if merchant.invoices.count < two_std_dev_below_average
    end.compact
  end

  def average_invoices_per_day
    (sales_engine.invoices.all.count/7.0).round(2)
  end

  def actual_invoices_per_day
    days = Hash.new(0)

    sales_engine.invoices.all.each do |invoice|
      day = invoice.created_at.strftime("%A")
      days[day] += 1
    end
    days
  end

  def average_invoices_per_day_standard_deviation
    average = average_invoices_per_day

    difference = actual_invoices_per_day.map do |_day, sales|
      (sales - average) ** 2
    end

    finish_standard_deviation(difference)
  end

  def top_days_by_invoice_count
    one_std_dev_above_average = average_invoices_per_day +
        average_invoices_per_day_standard_deviation
    actual_invoices_per_day.map do |day, sales|
      day if sales > one_std_dev_above_average
    end.compact
  end

  def invoice_status(status)
    status_count = sales_engine.invoices.all.reduce(0) do |count, invoice|
      count += 1 if invoice.status == status.to_sym
      count
    end

    percent = (status_count.to_f/sales_engine.invoices.all.count) * 100
    BigDecimal.new('%.2f' % percent).round(2).to_f
  end
end
