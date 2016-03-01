gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require 'minitest/pride'
require_relative "../lib/merchant_repository"
# require "merchant_repository"

class ItemRepositoryTest < Minitest::Test
  attr_accessor :merchant_repository

  def setup
    @merchant_repository = MerchantRepository.new("./data/merchants.csv")
  end

  # TEST EDGE CASES
  def test_returns_instance
    assert merchant_repository.instance_of?(MerchantRepository)
  end

  def test_all_method
    assert merchant_repository.all.instance_of?(Array)
  end

  def test_find_by_id
    assert merchant_repository.find_by_id("12334105").is_a?(Merchant)
    assert_equal "Shopin1901", merchant_repository.find_by_id("12334105").name
    assert_equal nil, merchant_repository.find_by_id("gfgjhk")
  end

  def test_find_by_name
    assert merchant_repository.find_by_name("Shopin1901").is_a?(Merchant)
    assert_equal "12334105", merchant_repository.find_by_name("Shopin1901").id
    assert_equal nil, merchant_repository.find_by_name("gfgjhk")
  end

  def test_find_all_by_price
    results = merchant_repository.find_all_by_name("shop")
    assert results.is_a?(Array)
    assert results[0].is_a?(Merchant)
    assert_equal 26, results.length

    results = merchant_repository.find_all_by_name("jsdhgfks")
    assert results.is_a?(Array)
    assert results.empty?
  end


end
