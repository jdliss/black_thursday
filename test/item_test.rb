gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require 'minitest/pride'
require_relative "../lib/item"
require_relative '../lib/item_repository'

class ItemTest < Minitest::Test
  attr_accessor :item
  def setup
    repository = ItemRepository.new("./data/items.csv")
    @item = repository.all[3]
  end

  def test_can_return_id_of_item
    assert_equal "263396013", item.id
  end

  def test_can_return_name_of_item
    assert_equal "Free standing Woden letters", item.name
  end

  def test_can_return_description_of_item
    description = "Free standing wooden letters\n\n15cm\n\nAny colours"
    assert_equal description, item.description
  end

  def test_can_return_unit_price_of_item
    assert_equal "700", item.unit_price
  end

  def test_can_return_merchant_id_of_item
    assert_equal "12334185", item.merchant_id
  end

  def test_can_return_created_at_of_item
    assert_equal "2016-01-11 11:51:36 UTC", item.created_at
  end

  def test_can_return_updated_at_of_item
    assert_equal "2001-09-17 15:28:43 UTC", item.updated_at
  end

  def test_unit_price_to_dollars
    assert_equal 700.0, item.unit_price_to_dollars
  end
end
