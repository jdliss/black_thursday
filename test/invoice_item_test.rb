require_relative 'test_helper'
require 'minitest/autorun'
require 'minitest/pride'
require 'time'
require_relative "../lib/sales_engine"
require_relative "../lib/invoice_item_repository"
require_relative "../lib/invoice_item"


class InvoiceItemTest < Minitest::Test
  attr_reader :invoice_item,
              :invoice_item_repo

  def setup
    se = SalesEngine.from_csv({
      :items     => "./data/items_small.csv",
      :merchants => "./data/merchants_small.csv",
      :invoices  => "./data/invoices_small.csv",
      :invoice_items => "./data/invoice_items_small.csv",
      :transactions  => "./data/transactions_small.csv",
      :customers => "./data/customers_small.csv"
    })

    @invoice_item_repo = se.invoice_items
    @invoice_item = @invoice_item_repo.all[0]

    end

    def test_can_find_id
      assert_equal 1, invoice_item.id
    end

    def test_can_find_item_id
      assert_equal 263395617, invoice_item.item_id
    end

    def test_can_find_invoice_id
      assert_equal 1, invoice_item.invoice_id
    end

    def test_can_find_quantity
      assert_equal 5, invoice_item.quantity
    end

    def test_can_find_unit_price
      assert_equal 136.35, invoice_item.unit_price
    end

    def test_can_find_when_it_was_created
      assert_equal Time.parse("2009-02-07 14:54:09 UTC"), invoice_item.created_at
    end

    def test_can_find_when_it_was_updated
      assert_equal Time.parse("2012-03-27 14:54:09 UTC"), invoice_item.updated_at
    end

    def test_calculate_unit_price_to_dollars
      assert_equal 136.35, invoice_item.unit_price_to_dollars
    end
  end
