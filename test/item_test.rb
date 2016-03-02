gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require 'minitest/pride'
require_relative "../lib/item"
require_relative '../lib/item_repository'
require_relative '../lib/sales_engine'

class ItemTest < Minitest::Test
  attr_accessor :items_repository,
                :item
  def setup
    se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
    })

    @items_repository = se.items
    @item = @items_repository.all[3]
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
    assert_equal 7.0, item.unit_price
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
    assert_equal 7.0, item.unit_price_to_dollars
  end

  def test_can_traverse_object_links_and_find_merchant_linked_to_item
    sales_engine = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv"})

    item2 = sales_engine.items.find_by_id("263408101")
    assert item2.is_a?(Item)

    assert item.item_repository.is_a?(ItemRepository)
    item_repository = item.item_repository

    merchant_repository = item_repository.sales_engine.merchant_repository
    assert merchant_repository.is_a?(MerchantRepository)

    items_merchant = merchant_repository.find_by_id(item2.merchant_id)
    assert items_merchant.is_a?(Merchant)

    assert_equal item2.merchant_id, items_merchant.id
  end

  def test_can_find_all_merchant_items_using_items_merchant_method
    new_item = @items_repository.all[3]

    assert new_item.is_a?(Item)
    assert new_item.merchant.is_a?(Merchant)
    assert_equal new_item.merchant_id, new_item.merchant.id
  end
end
