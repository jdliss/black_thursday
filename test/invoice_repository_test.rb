require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/sales_engine'
require_relative '../lib/invoice_repository'
require_relative '../lib/invoice'

class InvoiceRepositoryTest < Minitest::Test
  attr_accessor :invoice_repo

  def setup
    se = SalesEngine.from_csv({
      :items     => "./data/items_small.csv",
      :merchants => "./data/merchants_small.csv",
      :invoices  => "./data/invoices_small.csv"
    })

    @invoice_repo = se.invoices
  end

  # TODO TEST EDGE CASES
  def test_can_instantiate_object_of_invoice_repository
    assert invoice_repo.is_a?(InvoiceRepository)
  end

  def test_invoice_repository_holds_array_of_invoices
    assert invoice_repo.all.is_a?(Array)
    assert invoice_repo.all[0].is_a?(Invoice)
  end

  def test_can_find_invoice_by_id
    assert invoice_repo.find_by_id(1).is_a?(Invoice)
    assert_equal nil, invoice_repo.find_by_id("hjk")
  end

  def test_can_find_all_by_customer_id
    results = invoice_repo.find_all_by_customer_id(1)
    empty_results = invoice_repo.find_all_by_customer_id("lkjhg")

    assert results.is_a?(Array)
    refute results.empty?

    assert_equal [], empty_results
  end

  def test_can_find_all_by_merchant_id
    results = invoice_repo.find_all_by_merchant_id(12335938)
    empty_results = invoice_repo.find_all_by_merchant_id("fhgjh")

    assert results.is_a?(Array)
    assert results[0].is_a?(Invoice)

    assert_equal [], empty_results
  end

  def test_can_find_all_by_status
    results = invoice_repo.find_all_by_status(:shipped)

    assert results.is_a?(Array)
    assert_equal 7, results.count
    assert results[0].is_a?(Invoice)
  end
end
