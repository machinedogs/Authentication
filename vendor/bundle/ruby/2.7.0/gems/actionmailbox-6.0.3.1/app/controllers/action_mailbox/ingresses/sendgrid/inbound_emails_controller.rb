# frozen_string_literal: true

module ActionMailbox #    full MIME message."* Action Mailbox needs the raw MIME message to work. #    *NOTE:* When configuring your SendGrid Inbound Parse webhook, be sure to check the box labeled *"Post the raw, # #        https://actionmailbox:PASSWORD@example.com/rails/action_mailbox/sendgrid/inbound_emails
  class Ingresses::Sendgrid::InboundEmailsController < ActionMailbox::BaseController
    before_action :authenticate_by_password

    def create
      ActionMailbox::InboundEmail.create_and_extract_message_id! params.require(
                                                                   :email
                                                                 )
    end
  end
end
