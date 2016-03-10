require 'bigdecimal'
require_relative 'sales_engine'
require_relative 'standard_deviation'
require_relative 'parsing_most_sold_and_best_items'

class SalesAnalyst
  include StandardDeviation
  include ParsingMostSoldAndBestItems

  attr_accessor :sales_engine

  def initialize(sales_engine)
    @sales_engine = sales_engine
  end

  def merchants_with_high_item_count
    one_std_dev_above_average = average_items_per_merchant_standard_deviation +
        average_items_per_merchant

    sales_engine.merchants.all.map do |merchant|
      merchant if merchant.items.count > one_std_dev_above_average
    end.compact
  end

  def golden_items
    twice_avg_price_std_dev = average_item_price_standard_deviation * 2
    average_price = average_price_of_items

    sales_engine.items.all.map do |item|
      item if item.unit_price > twice_avg_price_std_dev + average_price
    end.compact
  end

  def top_merchants_by_invoice_count
    two_std_dev_above_average =
        (average_invoices_per_merchant_standard_deviation * 2) +
            average_invoices_per_merchant

    sales_engine.merchants.all.map do |merchant|
      merchant if merchant.invoices.count > two_std_dev_above_average
    end.compact
  end

  def bottom_merchants_by_invoice_count
    two_std_dev_below_average =
        average_invoices_per_merchant -
            (average_invoices_per_merchant_standard_deviation * 2)

    sales_engine.merchants.all.map do |merchant|
      merchant if merchant.invoices.count < two_std_dev_below_average
    end.compact
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

  def total_revenue_by_date(date)
    invoices_on_date(date).reduce(0) do |total, invoice|
      if invoice.total.nil?
        total += 0
      else
        total += invoice.total
      end
    end
  end

  def top_revenue_earners(num=20)
    top_earners = Hash.new
    all_merchants.map do |merchant|
      top_earners[merchant] = merchant.revenue_for_merchant
    end

    top_earners.sort_by do |pair|
      pair[1]
    end.to_h.keys.reverse[0..(num-1)]
  end

  def merchants_ranked_by_revenue
    top_revenue_earners(0)
  end

  def merchants_with_pending_invoices
    all_merchants.map do |merchant|
      merchant if merchant.invoices.any? do |invoice|
        !invoice.is_paid_in_full?
      end
    end.compact
  end

  def merchants_with_only_one_item
    all_merchants.map do |merchant|
      merchant if merchant.items.length == 1
    end.compact
  end

  def merchants_with_only_one_item_registered_in_month(month)
    merchants_with_only_one_item.find_all do |merchant|
      merchant.created_at.strftime("%B").downcase == month.downcase
    end
  end

  def revenue_by_merchant(merchant_id)
    merchant = sales_engine.merchants.find_by_id(merchant_id)
    merchant.revenue_for_merchant
  end

  def most_sold_item_for_merchant(merchant_id)
    most_sold = Hash.new(0)
    merchant = sales_engine.merchants.find_by_id(merchant_id)

    merchant.successful_invoices.map do |invoice|
      invoice.invoice_items.map do |invoice_item|
        most_sold[invoice_item.item_id] += invoice_item.quantity
      end
    end
    sort_most_sold(most_sold)
  end

  def best_item_for_merchant(merchant_id)
    best_items = Hash.new(0)
    merchant = sales_engine.merchants.find_by_id(merchant_id)

    merchant.successful_invoices.map do |invoice|
      invoice.invoice_items.map do |invoice_item|
        best_items[invoice_item.item_id] += invoice_item.unit_price *
                                              invoice_item.quantity
      end
    end
    find_best_item(best_items)
  end
end
