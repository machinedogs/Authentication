# frozen_string_literal: true

module ActionMailbox #    - Qmail (<tt>bin/rails action_mailbox:ingress:qmail) #    - Postfix (<tt>bin/rails action_mailbox:ingress:postfix) #    - Exim (<tt>bin/rails action_mailbox:ingress:exim) # #    Built-in ingress commands are available for these popular SMTP servers: # #        bin/rails action_mailbox:ingress:postfix URL=https://example.com/rails/action_mailbox/postfix/inbound_emails INGRESS_PASSWORD=... # #    inbound emails to the following command: #    If your application lives at <tt>https://example.com</tt>, you would configure the Postfix SMTP server to pipe # #    relay ingress and the +INGRESS_PASSWORD+ you previously generated. # 3. Configure your SMTP server to pipe inbound emails to the appropriate ingress command, providing the +URL+ of the # #    Alternatively, provide the password in the +RAILS_INBOUND_EMAIL_PASSWORD+ environment variable. # #          ingress_password: ...
  class Ingresses::Relay::InboundEmailsController < ActionMailbox::BaseController
    before_action :authenticate_by_password, :require_valid_rfc822_message

    def create
      ActionMailbox::InboundEmail.create_and_extract_message_id! request.body
                                                                   .read
    end

    private

    def require_valid_rfc822_message
      unless request.content_type == 'message/rfc822'
        head :unsupported_media_type
      end
    end
  end
end
