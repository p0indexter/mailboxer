class Mailboxer::Message < Mailboxer::Notification
  attr_accessible :attachment if Mailboxer.protected_attributes?
  self.table_name = :mailboxer_notifications

  belongs_to :conversation, :validate => true, :autosave => true
  validates_presence_of :sender

  has_many :receipts,  :class_name => "Mailboxer::Receipt"

  class_attribute :on_deliver_callback
  protected :on_deliver_callback
  scope :conversation, lambda { |conversation|
    where(:conversation_id => conversation.id)
  }

  mount_uploader :attachment, Mailboxer::AttachmentUploader



  #Mark the conversation as read for one of the participants
  def mark_as_read(participant)
    return unless participant
    self.receipts.recipient(participant).mark_as_read
  end

  #Mark the conversation as unread for one of the participants
  def mark_as_unread(participant)
    return unless participant
    self.receipts.recipient(participant).mark_as_unread
  end

  #Mark the conversation as important
  def mark_as_important(participant)
    return unless participant
    self.receipts.recipient(participant).mark_as_important
  end

  #Mark the conversation as important
  def mark_as_unimportant(participant)
    return unless participant
    self.receipts.recipient(participant).mark_as_unimportant
  end

  #Move the conversation to the trash for one of the participants
  def move_to_trash(participant)
    return unless participant
    self.receipts.recipient(participant).move_to_trash
  end

  #Takes the conversation out of the trash for one of the participants
  def untrash(participant)
    return unless participant
    self.receipts.recipient(participant).untrash
  end



  class << self
    #Sets the on deliver callback method.
    def on_deliver(callback_method)
      self.on_deliver_callback = callback_method
    end
  end

  #Delivers a Message. USE NOT RECOMENDED.
  #Use Mailboxer::Models::Message.send_message instead.
  def deliver(reply = false, should_clean = true)
    self.clean if should_clean

    #Receiver receipts
    receiver_receipts = recipients.map do |r|
      receipts.build(receiver: r, mailbox_type: 'inbox', is_read: false)
    end

    #Sender receipt
    sender_receipt =
      receipts.build(receiver: sender, mailbox_type: 'sentbox', is_read: true)

    if valid?
      save!
      Mailboxer::MailDispatcher.new(self, receiver_receipts).call

      conversation.touch if reply

      self.recipients = nil

      on_deliver_callback.call(self) if on_deliver_callback
    end
    sender_receipt
  end
end
