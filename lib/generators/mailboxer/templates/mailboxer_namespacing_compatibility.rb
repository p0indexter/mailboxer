class MailboxerNamespacingCompatibility < ActiveRecord::Migration

  def self.up
    rename_table :conversations, :plugins_mailboxer_conversations
    rename_table :notifications, :plugins_mailboxer_notifications
    rename_table :receipts,      :plugins_mailboxer_receipts

    Mailboxer::Notification.where(type: 'Message').update_all(type: '::Plugins::Mailboxer::Message')
  end

  def self.down
    rename_table :plugins_mailboxer_conversations, :conversations
    rename_table :plugins_mailboxer_notifications, :notifications
    rename_table :plugins_mailboxer_receipts,      :receipts

    ::Plugins::Mailboxer::Notification.table_name = "notifications"
    ::Plugins::Mailboxer::Notification.where(type: '::Plugins::Mailboxer::Message').update_all(type: 'Message')
  end
end
