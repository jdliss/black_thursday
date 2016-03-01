require_relative 'item_repository'
require_relative 'merchant_repository'
require 'csv'
require 'pry'

class SalesEngine
  def self.from_csv(file_hash)
    @merchants = MerchantRepository.new(file_hash[:merchants])
    @items = ItemRepository.new(file_hash[:items])

    SalesEngine
  end

  def self.merchants
    @merchants
  end

  def self.items
    @items
  end
end
