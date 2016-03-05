require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/sales_engine'
require_relative '../lib/transaction_repository'
require_relative '../lib/transaction'


class TransactionRepositoryTest < Minitest::Test
  attr_accessor :transaction_repository

  def setup
    se = SalesEngine.from_csv({
      :items     => "./data/items_small.csv",
      :merchants => "./data/merchants_small.csv",
      :invoices  => "./data/invoices_small.csv",
      :invoice_items => "./data/invoice_items_small.csv",
      :transactions  => "./data/transactions_small.csv"
    })

    @transaction_repository = se.transactions
  end

  def test_can_find_all_transactions
    assert transaction_repository.all.is_a?(Array)
    assert transaction_repository.all[0].is_a?(Transaction)
  end

  def test_can_find_transction_by_id
    assert transaction_repository.find_by_id(1).is_a?(Transaction)
  end

  def test_can_find_all_transactions_by_invoice_id
    assert transaction_repository.find_all_by_invoice_id(2179).is_a?(Array)
    assert_equal 2, transaction_repository.find_all_by_invoice_id(2179).length
  end

  def test_can_find_all_transactions_by_credit_card_number
    assert transaction_repository.find_all_by_credit_card_number(4149654190362629).is_a?(Array)
    assert_equal 2, transaction_repository.find_all_by_credit_card_number(4149654190362629).length
  end

  def test_can_find_all_transactions_by_result
    assert transaction_repository.find_all_by_result("success").is_a?(Array)
    assert_equal 9, transaction_repository.find_all_by_result("success").length
  end
end
