gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require 'minitest/pride'
require_relative "../lib/sales_engine"
# require "sales_engine"

class SalesEngineTest < Minitest::Test
  def test_sales_engine_instance
    se = SalesEngine.new

    assert se
  end

  def test_sales_engine_from_csv
    se = SalesEngine.new
    from_csv = se.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",})

    assert ItemRepository, se.items
    # assert MerchantRepository, se.merchants
  end


end
