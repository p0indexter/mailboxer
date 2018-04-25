class Plugins::Mailboxer::ConversationBuilder < Mailboxer::BaseBuilder

  protected

  def klass
    Plugins::Mailboxer::Conversation
  end
end
