class Merchant
  attr_accessor :merchant
  
  def initialize(merchant)
    @merchant = merchant
  end

  def id
    merchant[0]
  end

  def name
    merchant[1]
  end
end
