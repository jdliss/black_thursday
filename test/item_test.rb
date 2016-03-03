gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require 'minitest/pride'
require 'time'
require_relative "../lib/item"
require_relative '../lib/item_repository'
require_relative '../lib/sales_engine'

class ItemTest < Minitest::Test
  attr_accessor :items_repository,
                :item
  def setup
    se = SalesEngine.from_csv({
      :items     => "./data/items_small.csv",
      :merchants => "./data/merchants_small.csv",
    })

    @items_repository = se.items
    @item = @items_repository.all[0]
  end

# TODO TEST EDGE CASES
  def test_can_return_id_of_item
    assert_equal 263395617, item.id
  end

  def test_can_return_name_of_item
    assert_equal "Glitter scrabble frames", item.name
  end

  def test_can_return_description_of_item
    description = "Glitter scrabble frames\n\nAny colour glitter\nAny wording\n
Available colour scrabble tiles\nPink\nBlue\nBlack\nWooden"
    assert_equal description, item.description
  end

  def test_can_return_unit_price_of_item
    assert_equal 13.0, item.unit_price
  end

  def test_can_return_merchant_id_of_item
    assert_equal 12334185, item.merchant_id
  end

  def test_can_return_created_at_of_item
    assert_equal Time.parse("2016-01-11 11:51:37 UTC"), item.created_at
  end

  def test_can_return_updated_at_of_item
    assert_equal Time.parse("1993-09-29 11:56:40 UTC"), item.updated_at
  end

  def test_unit_price_to_dollars
    assert_equal 13.0, item.unit_price_to_dollars
  end

  def test_can_traverse_object_links_and_find_merchant_linked_to_item
    sales_engine = SalesEngine.from_csv({
      :items     => "./data/items_small.csv",
      :merchants => "./data/merchants_small.csv"})

    item2 = sales_engine.items.find_by_id(263396013)
    assert item2.is_a?(Item)

    assert item.item_repository.is_a?(ItemRepository)
    item_repository = item.item_repository

    merchant_repository = item_repository.sales_engine.merchants
    assert merchant_repository.is_a?(MerchantRepository)

    items_merchant = merchant_repository.find_by_id(item2.merchant_id.to_i)
    assert items_merchant.is_a?(Merchant)

    assert_equal item2.merchant_id.to_i, items_merchant.id
  end

  def test_can_find_all_merchant_items_using_items_merchant_method
    new_item = @items_repository.all[3]

    assert new_item.is_a?(Item)
    assert new_item.merchant.is_a?(Merchant)
    assert_equal new_item.merchant_id.to_i, new_item.merchant.id
  end
end
