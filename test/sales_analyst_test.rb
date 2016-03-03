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
    assert_equal 1.67, sa.average_items_per_merchant
  end

  def test_average_items_per_merchant_standard_deviation
    assert_equal 0.87, sa.average_items_per_merchant_standard_deviation
  end

  def test_find_merchants_with_high_item_count
    assert sa.merchants_with_high_item_count[0].is_a?(Merchant)
    assert sa.merchants_with_high_item_count[1].is_a?(Merchant)
    assert_equal 2, sa.merchants_with_high_item_count.length
  end

  def test_average_item_price_for_merchant
    assert_equal 11, sa.average_item_price_for_merchant('12334185')
  end

  def test_average_average_price_per_merchant
    assert_equal 62.47, sa.average_average_price_per_merchant
  end

  def test_can_find_average_item_prices
    assert_equal 68.93, sa.average_price_of_items
  end

  def test_can_find_standard_deviation_of_item_prices
    assert_equal 97.62, sa.average_item_price_standard_deviation
  end

  def test_can_find_golden_items

    assert sa.golden_items.is_a?(Array)
    assert_equal 1, sa.golden_items.count
  end
end
