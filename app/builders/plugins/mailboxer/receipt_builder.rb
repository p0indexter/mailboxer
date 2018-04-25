class Plugins::Mailboxer::ReceiptBuilder < Mailboxer::BaseBuilder

  protected

  def klass
    Plugins::Mailboxer::Receipt
  end

  def mailbox_type
    params.fetch(:mailbox_type, 'inbox')
  end

end
