gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require 'minitest/pride'
require 'csv'
require_relative "../lib/item_repository"
require_relative "../lib/sales_engine"
# require "item_repository"

class ItemRepositoryTest < Minitest::Test
  attr_accessor :items_repository

  def setup
    se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
    })

    @items_repository = se.items
  end

  # TEST FOR EDGE CASES
  def test_returns_instance
    assert items_repository.is_a?(ItemRepository)
  end

  def test_all_method
    assert items_repository.all.is_a?(Array)
  end

  def test_find_by_id
    assert items_repository.find_by_id("263403127").is_a?(Item)
    assert_equal "Knitted winter snood", items_repository.find_by_id("263403127").name
    assert_equal nil, items_repository.find_by_id("gfgjhk")
  end

  def test_find_by_name
    assert items_repository.find_by_name("Knitted winter snood").is_a?(Item)
    assert_equal "263403127", items_repository.find_by_name("Knitted winter snood").id
    assert_equal nil, items_repository.find_by_name("gfgjhk")
  end
  #
  def test_find_all_by_description
    results = items_repository.find_all_with_description("These")
    assert results.is_a?(Array)
    assert results[0].is_a?(Item)
    assert_equal 122, results.length

    results = items_repository.find_all_with_description("skdhfkshjf")

    assert results.is_a?(Array)
    assert results.empty?
  end

  def test_find_all_by_price
    results = items_repository.find_all_by_price(400)
    assert results.is_a?(Array)
    assert results[0].is_a?(Item)
    assert_equal 7, results.length

    results = items_repository.find_all_by_price(35465768798)
    assert results.is_a?(Array)
    assert results.empty?
  end

  def test_find_all_by_price_in_range
    results = items_repository.find_all_by_price_in_range(12..13)
    assert results.is_a?(Array)
    assert results[0].is_a?(Item)
    assert_equal 56, results.length

    results = items_repository.find_all_by_price_in_range(100000000..200000000)
    assert results.is_a?(Array)
    assert results.empty?
  end

  def test_find_all_by_merchant_id
    results = items_repository.find_all_by_merchant_id("12334185")
    assert results.is_a?(Array)
    assert results[0].is_a?(Item)
    assert_equal 6, results.length

    results = items_repository.find_all_by_merchant_id("ksdhkj")
    assert results.is_a?(Array)
    assert results.empty?
  end
end
