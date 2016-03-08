require_relative 'test_helper'
require 'time'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/sales_engine'
require_relative '../lib/sales_analyst'

class SalesAnalystTest < Minitest::Test
  attr_accessor :sa

  def setup
    se = SalesEngine.from_csv({
      :items     => "./data/items_small.csv",
      :merchants => "./data/merchants_small.csv",
      :invoices  => "./data/invoices_small.csv",
      :invoice_items => "./data/invoice_items_small.csv",
      :transactions  => "./data/transactions_small.csv",
      :customers => "./data/customers_small.csv"
    })


    @sa = SalesAnalyst.new(se)
  end

  # TODO TEST EDGE CASES
  def test_can_make_sales_analyst_object_with_sales_engine_object_as_input
    se = SalesEngine.from_csv({
      :items     => "./data/items_small.csv",
      :merchants => "./data/merchants_small.csv",
    })


    sa = SalesAnalyst.new(se)
  end

  def test_find_average_number_of_items_per_merchant
    assert_equal 1.9, sa.average_items_per_merchant
  end

  def test_average_items_per_merchant_standard_deviation
    assert_equal 0.9, sa.average_items_per_merchant_standard_deviation
  end

  def test_find_merchants_with_high_item_count
    assert_equal 2, sa.merchants_with_high_item_count.length
    assert sa.merchants_with_high_item_count[0].is_a?(Merchant)
    assert sa.merchants_with_high_item_count[1].is_a?(Merchant)
  end

  def test_average_item_price_for_merchant
    assert_equal 11, sa.average_item_price_for_merchant(12334185)
  end

  def test_average_average_price_per_merchant
    assert_equal 64.22, sa.average_average_price_per_merchant
  end

  def test_can_find_average_item_prices
    assert_equal 69.51, sa.average_price_of_items
  end

  def test_can_find_standard_deviation_of_item_prices
    assert_equal 94.9, sa.average_item_price_standard_deviation
  end

  def test_can_find_golden_items
    assert sa.golden_items.is_a?(Array)
    assert_equal 1, sa.golden_items.count
  end

  def test_can_find_average_invoices_per_merchant
    assert_equal 1.0, sa.average_invoices_per_merchant
  end

  def test_can_find_average_invoices_per_merchant_standard_deviation
    assert_equal 1.37, sa.average_invoices_per_merchant_standard_deviation
  end

  def test_can_merchants_with_invoice_count_two_standard_deviations_above_average
    assert_equal 1, sa.top_merchants_by_invoice_count.length
    assert sa.top_merchants_by_invoice_count[0].is_a?(Merchant)
  end

  def test_can_merchants_with_invoice_count_two_standard_deviations_below_average
    assert_equal [], sa.bottom_merchants_by_invoice_count
  end

  def test_average_invoices_per_day
    assert_equal 1.43, sa.average_invoices_per_day
  end

  def test_average_invoices_per_day_standard_deviation
    assert_equal 1.38, sa.average_invoices_per_day_standard_deviation
  end

  def test_top_days_by_invoice_count
    assert_equal ["Friday"], sa.top_days_by_invoice_count
  end

  def test_can_calculate_status_percent_of_whole
    assert_equal 10, sa.invoice_status(:returned)
    assert_equal 20, sa.invoice_status(:pending)
    assert_equal 70, sa.invoice_status(:shipped)
  end

  def test_can_calculate_total_revenue_for_a_given_date
    date = Time.parse("2009-02-07")
    assert_equal 21067.77, sa.total_revenue_by_date(date).to_f
  end

  def test_top_x_merchant_revenue_earners
    assert_equal 5, sa.top_revenue_earners(5).length
    assert_equal Merchant, sa.top_revenue_earners(5)[0].class
    assert_equal 10, sa.top_revenue_earners.length
  end

  def test_find_merchants_with_pending_invoices
    assert sa.merchants_with_pending_invoices.is_a?(Array)
    assert sa.merchants_with_pending_invoices[0].is_a?(Merchant)
  end

  def test_merhants_ranked_by_revenue
    assert_equal 10, sa.merchants_ranked_by_revenue.length
  end

  def test_merchants_with_only_one_item
    assert_equal 6, sa.merchants_with_only_one_item.length
  end

  def test_merchant_with_only_one_item_registered_in_month
    assert_equal 3, sa.merchants_with_only_one_item_registered_in_month("march").length
  end

  def test_revenue_by_merchant
    assert_equal 21067.77, sa.revenue_by_merchant(12335938)
  end

  def test_most_sold_item_for_merchant
    assert sa.most_sold_item_for_merchant(12335938).is_a?(Array)
    assert sa.most_sold_item_for_merchant(12335938)[0].is_a?(Item)
    assert_equal 1, sa.most_sold_item_for_merchant(12335938).count
  end

  def test_best_item_for_merchant
    assert sa.best_item_for_merchant(12335938).is_a?(Item)
  end
end
