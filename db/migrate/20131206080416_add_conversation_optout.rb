class AddConversationOptout < ActiveRecord::Migration
  def self.up
    create_table :plugins_mailboxer_conversation_opt_outs do |t|
      t.references :unsubscriber, :polymorphic => true
      t.references :conversation
    end
    add_foreign_key "plugins_mailboxer_conversation_opt_outs", "mailboxer_conversations", :name => "mb_opt_outs_on_conversations_id", :column => "conversation_id"
  end

  def self.down
    remove_foreign_key "plugins_mailboxer_conversation_opt_outs", :name => "mb_opt_outs_on_conversations_id"
    drop_table :plugins_mailboxer_conversation_opt_outs
  end
end
