require_relative 'item_repository'
require_relative 'merchant_repository'
require 'csv'
require 'pry'

class SalesEngine
  def initialize(item_repository, merchant_repository)
    @items = item_repository
    @merchants = merchant_repository
  end

  def self.from_csv(file_hash)
    merchants_table = load_merchants(file_hash[:merchants])
    items_table = load_items(file_hash[:items])

    @merchant_repository_object = MerchantRepository.new(merchants_table, self)
    @item_repository_object = ItemRepository.new(items_table, self)

    SalesEngine.new(@item_repository_object, @merchant_repository_object)
  end

  def self.load_items(file_path)
    CSV.readlines(file_path, headers: true)
  end

  def self.load_merchants(file_path)
    CSV.readlines(file_path, headers: true)
  end

  def items
    @items
  end

  def merchants
    @merchants
  end

  def self.item_repository
    @item_repository_object
  end

  def self.merchant_repository
    @merchant_repository_object
  end
end
