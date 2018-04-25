class AddDeliveryTrackingInfoToMailboxerReceipts < ActiveRecord::Migration
  def change
  	add_column :plugins_mailboxer_receipts, :is_important, :boolean, default: false
    add_column :plugins_mailboxer_receipts, :is_delivered, :boolean, default: false
    add_column :plugins_mailboxer_receipts, :delivery_method, :string
    add_column :plugins_mailboxer_receipts, :message_id, :string
  end
end
