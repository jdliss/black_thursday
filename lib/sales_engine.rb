require_relative 'item_repository'
require_relative 'merchant_repository'
require 'csv'
require 'pry'

class SalesEngine
  attr_accessor :items,
                :merchants

  def from_csv(file_hash)
    @items = ItemRepository.new(file_hash[:items])
    # @merchants = MerchantRepository.new(file_hash[:merchants])
  end

end
