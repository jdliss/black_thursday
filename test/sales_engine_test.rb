require_relative 'test_helper'
require 'minitest/autorun'
require 'minitest/pride'
require_relative "../lib/sales_engine"

class SalesEngineTest < Minitest::Test
  def test_sales_engine_from_csv
    se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",})

    assert ItemRepository, se.items
    assert MerchantRepository, se.merchants
  end
end
