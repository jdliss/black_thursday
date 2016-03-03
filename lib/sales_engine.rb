require_relative 'item_repository'
require_relative 'merchant_repository'
require 'csv'
require 'pry'

class SalesEngine
  attr_reader :items,
              :merchants,
              :invoices


  def initialize(items_table=nil, merchants_table=nil, invoice_table=nil)
    @items = ItemRepository.new(items_table, self) if items_table
    @merchants = MerchantRepository.new(merchants_table, self) if merchants_table
    @invoices = InvoiceRepository.new(invoice_table, self) if invoice_table
  end

  def self.from_csv(file_hash)
    merchants_table = load_data(file_hash[:merchants]) if file_hash[:merchants]
    items_table = load_data(file_hash[:items]) if file_hash[:items]
    invoices_table = load_data(file_hash[:invoices]) if file_hash[:invoices]

    SalesEngine.new(items_table, merchants_table, invoices_table)
  end

  def self.load_data(file_path)
    CSV.readlines(file_path, headers: true)
  end
end
