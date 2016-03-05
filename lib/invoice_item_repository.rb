
class InvoiceItemRepository
  attr_accessor :sales_engine,
                :invoice_items

  def initialize(invoice_item_data, sales_engine)
    @sales_engine = sales_engine

    @invoice_items = invoice_item_data.map do |invoice_item|
      InvoiceItem.new(invoice_item, self)
    end
  end

  def inspect
    "#<#{self.class} #{@invoice_items.size} rows>"
  end

  def all
    invoice_items
  end

  def find_by_id(id)
    invoice_items.find { |invoice_item| invoice_item.id == id }
  end

  def find_all_by_item_id(item_id)
    invoice_items.find_all { |invoice_item| invoice_item.item_id == item_id}
  end

  def find_all_by_invoice_id(invoice_id)
    invoice_items.find_all { |invoice_item| invoice_item.invoice_id == invoice_id }
  end
end
