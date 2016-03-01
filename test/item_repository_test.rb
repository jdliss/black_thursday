gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require 'minitest/pride'
require_relative "../lib/item_repository"

class ItemRepositoryTest < Minitest::Test
  attr_accessor :repository

  def setup
    @repository = ItemRepository.new("./data/items.csv")
  end

  # TEST FOR EDGE CASES
  def test_returns_instance
    assert repository.instance_of?(ItemRepository)
  end

  def test_all_method
    assert repository.all.instance_of?(Array)
  end

  def test_find_by_id
    assert repository.find_by_id("263403127").is_a?(Item)
    assert_equal "Knitted winter snood", repository.find_by_id("263403127").name
    assert_equal nil, repository.find_by_id("gfgjhk")
  end

  def test_find_by_name
    assert repository.find_by_name("Knitted winter snood").is_a?(Item)
    assert_equal "263403127", repository.find_by_name("Knitted winter snood").id
    assert_equal nil, repository.find_by_name("gfgjhk")
  end

  def test_find_all_by_description
    results = repository.find_all_with_description("These")
    assert results.is_a?(Array)
    assert_equal 122, results.length

    results = repository.find_all_with_description("skdhfkshjf")

    assert results.is_a?(Array)
    assert results.empty?
  end

  def test_find_all_by_price
    results = repository.find_all_by_price(1200)
    assert results.is_a?(Array)
    assert_equal 41, results.length

    results = repository.find_all_by_price(35465768798)
    assert results.is_a?(Array)
    assert results.empty?
  end

  def test_find_all_by_price_in_range
    results = repository.find_all_by_price_in_range(100..200)
    assert results.is_a?(Array)
    assert_equal 10, results.length

    results = repository.find_all_by_price_in_range(1000000..2000000)
    assert results.is_a?(Array)
    assert results.empty?
  end

  def test_find_all_by_merchant_id
    results = repository.find_all_by_merchant_id("12334185")
    assert results.is_a?(Array)
    assert_equal 6, results.length

    results = repository.find_all_by_merchant_id("ksdhkj")
    assert results.is_a?(Array)
    assert results.empty?
  end
end
