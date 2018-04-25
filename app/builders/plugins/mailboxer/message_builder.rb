class Plugins::Mailboxer::MessageBuilder < Mailboxer::BaseBuilder

  protected

  def klass
    Plugins::Mailboxer::Message
  end
end
