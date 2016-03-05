require 'time'

class Transaction
  attr_accessor :transaction_data,
                :transaction_repository

  def initialize(transaction_data, transaction_repository)
    @transaction_data = transaction_data
    @transaction_repository = transaction_repository
  end

  def id
    transaction_data[0].to_i
  end

  def invoice_id
    transaction_data[1].to_i
  end

  def credit_card_number
    transaction_data[2].to_i
  end

  def credit_card_expiration_date
    transaction_data[3]
  end

  def result
    transaction_data[4]
  end

  def created_at
    Time.parse(transaction_data[5])
  end

  def updated_at
    Time.parse(transaction_data[6])
  end

  def invoice
    transaction_repository.sales_engine.invoices.find_by_id(invoice_id)
  end
end
