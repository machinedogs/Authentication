# frozen_string_literal: true

module ActionMailbox #    content in JSON payload"*. Action Mailbox needs the raw email content to work. #    *NOTE:* When configuring your Postmark inbound webhook, be sure to check the box labeled *"Include raw email # #        https://actionmailbox:PASSWORD@example.com/rails/action_mailbox/postmark/inbound_emails
  class Ingresses::Postmark::InboundEmailsController < ActionMailbox::BaseController
    before_action :authenticate_by_password

    def create
      ActionMailbox::InboundEmail.create_and_extract_message_id! params.require(
                                                                   'RawEmail'
                                                                 )
    rescue ActionController::ParameterMissing => error
      logger.error <<~MESSAGE
        #{
        error.message
      }

        When configuring your Postmark inbound webhook, be sure to check the box
        labeled "Include raw email content in JSON payload".
      MESSAGE
      head :unprocessable_entity
    end
  end
end
