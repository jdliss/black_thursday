require_relative 'test_helper'
require 'minitest/autorun'
require 'minitest/pride'
require 'time'
require_relative "../lib/sales_engine"
require_relative "../lib/invoice_item_repository"
require_relative "../lib/invoice_item"


class InvoiceItemRepositoryTest < Minitest::Test
  attr_accessor :invoice_items_repo
  def setup
    se = SalesEngine.from_csv({
      :items     => "./data/items_small.csv",
      :merchants => "./data/merchants_small.csv",
      :invoices  => "./data/invoices_small.csv",
      :invoice_items => "./data/invoice_items_small.csv"
    })

    @invoice_items_repo = se.invoice_items
  end

  def test_can_return_all_invoice_items
    assert invoice_items_repo.all.is_a?(Array)
    assert invoice_items_repo.all[0].is_a?(InvoiceItem)
  end

  def test_can_find_invoice_item_by_id
    assert invoice_items_repo.find_by_id(1).is_a?(InvoiceItem)
    assert_equal nil, invoice_items_repo.find_by_id('slkdfj')
  end

  def test_can_find_find_all_invoice_items_by_item_id
    assert invoice_items_repo.find_all_by_item_id(263542298).is_a?(Array)
    assert invoice_items_repo.find_all_by_item_id(263542298)[0].is_a?(InvoiceItem)
    assert_equal nil, invoice_items_repo.find_all_by_item_id("ksjdhfj")[0]
  end

  def test_can_find_all_invoice_items_by_invoice_id
    assert invoice_items_repo.find_all_by_invoice_id(1).is_a?(Array)
    assert invoice_items_repo.find_all_by_invoice_id(1)[0].is_a?(InvoiceItem)
    assert_equal nil, invoice_items_repo.find_all_by_invoice_id("ksjdhfj")[0]
  end
end
