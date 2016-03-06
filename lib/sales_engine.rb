require_relative 'item_repository'
require_relative 'merchant_repository'
require_relative 'invoice_repository'
require_relative 'invoice_item_repository'
require_relative 'transaction_repository'
require_relative 'customer_repository'
require 'csv'

class SalesEngine
  attr_reader :items,
              :merchants,
              :invoices,
              :invoice_items,
              :transactions,
              :customers


  def initialize(items_table=nil, merchants_table=nil, invoice_table=nil,
     invoice_items_table=nil, transactions_table=nil, customers_table=nil)

    @items = ItemRepository.new(items_table, self) if
        items_table
    @merchants = MerchantRepository.new(merchants_table, self) if
        merchants_table
    @invoices = InvoiceRepository.new(invoice_table, self) if
        invoice_table
    @invoice_items = InvoiceItemRepository.new(invoice_items_table, self) if
        invoice_items_table
    @transactions = TransactionRepository.new(transactions_table, self) if
        transactions_table
    @customers = CustomerRepository.new(customers_table, self) if
        customers_table
  end


  def self.from_csv(file_hash)
    merchants_table = load_data(file_hash[:merchants]) if
        file_hash[:merchants]
    items_table = load_data(file_hash[:items]) if
        file_hash[:items]
    invoices_table = load_data(file_hash[:invoices]) if
        file_hash[:invoices]
    invoice_items_table = load_data(file_hash[:invoice_items]) if
        file_hash[:invoice_items]
    transactions_table = load_data(file_hash[:transactions]) if
        file_hash[:transactions]
    customers_table = load_data(file_hash[:customers]) if
        file_hash[:customers]

    SalesEngine.new(items_table, merchants_table, invoices_table,
     invoice_items_table, transactions_table, customers_table)
  end

  def self.load_data(file_path)
    CSV.readlines(file_path, headers: true)
  end
end
