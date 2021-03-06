require_relative 'test_helper'
require 'minitest/autorun'
require 'minitest/pride'
require_relative "../lib/merchant_repository"
require_relative "../lib/sales_engine"

class MerchantRepositoryTest < Minitest::Test
  attr_accessor :merchant_repository

  def setup
    se = SalesEngine.from_csv({
      :items     => "./data/items_small.csv",
      :merchants => "./data/merchants_small.csv",
    })

    @merchant_repository = se.merchants
  end

  # TODO TEST EDGE CASES
  def test_returns_instance
    assert merchant_repository.instance_of?(MerchantRepository)
  end

  def test_all_method
    assert merchant_repository.all.instance_of?(Array)
  end

  def test_find_by_id
    assert merchant_repository.find_by_id(12334105).is_a?(Merchant)
    assert_equal "Shopin1901", merchant_repository.find_by_id(12334105).name
    assert_equal nil, merchant_repository.find_by_id("gfgjhk")
  end

  def test_find_by_name
    assert merchant_repository.find_by_name("Shopin1901").is_a?(Merchant)
    assert_equal 12334105, merchant_repository.find_by_name("Shopin1901").id
    assert_equal nil, merchant_repository.find_by_name("gfgjhk")
  end

  def test_find_all_by_price
    results = merchant_repository.find_all_by_name("Madewithgitterxx")
    assert results.is_a?(Array)
    assert results[0].is_a?(Merchant)
    assert_equal 1, results.length

    results = merchant_repository.find_all_by_name("jsdhgfks")
    assert results.is_a?(Array)
    assert results.empty?
  end

  def test_find_all_merchant_by_month_created
    assert_equal 3, merchant_repository.merchants_created_in_month("March").count
  end
end
