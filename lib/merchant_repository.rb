require 'csv'
require 'pry'
require_relative 'merchant'

class MerchantRepository
  attr_accessor :merchants
  def initialize(file_path)
    csv_table = CSV.readlines(file_path, headers: true)

    @merchants = csv_table.map do |merchant|
      Merchant.new(merchant)
    end
    @merchants
  end

  def all
    merchants
  end

  def find_by_id(merchant_id)
    merchants.find { |merchant| merchant.id == merchant_id }
  end

  def find_by_name(merchant_name)
    merchants.find { |merchant| merchant.name.downcase == merchant_name.downcase }
  end

  def find_all_by_name(merchant_name)
    merchants.find_all { |merchant| merchant.name.downcase.include?(merchant_name.downcase) }
  end

end
