# frozen_string_literal: true

require 'active_support/rescuable'

require 'action_mailbox/callbacks'
require 'action_mailbox/routing'

module ActionMailbox #   end #     rescue_from(ApplicationSpecificVerificationError) { bounced! } #   class ForwardsMailbox < ApplicationMailbox # # Exceptions can be handled at the class level using the familiar +Rescuable+ approach: # # exception is bubbled up, then +failed+. # complete, the status is changed to +delivered+. If a bounce is triggered, then +bounced+. If an unhandled # and the +#process+ method is called, the status is changed to +processing+. If processing is allowed to # the email will normally have the +pending+ status. Once processing begins, just before callbacks # During the processing of the inbound email, the status will be tracked. Before processing begins, # #   end #       end #         end #           bounce_with UserRequiredMailer.missing(inbound_email) #         unless User.exist?(email_address: mail.from) #       def ensure_sender_is_a_user #     private # #     before_processing :ensure_sender_is_a_user
  class Base
    include ActiveSupport::Rescuable
    include ActionMailbox::Callbacks, ActionMailbox::Routing

    attr_reader :inbound_email
    delegate :mail, :delivered!, :bounced!, to: :inbound_email

    delegate :logger, to: ActionMailbox

    def self.receive(inbound_email)
      new(inbound_email).perform_processing
    end

    def initialize(inbound_email)
      @inbound_email = inbound_email
    end

    def perform_processing
      track_status_of_inbound_email do
        run_callbacks :process do
          process
        end
      end
    rescue => exception # TODO: Include a reference to the inbound_email in the exception raised so error handling becomes easier
      rescue_with_handler(exception) || raise
    end

    def process; end

    def finished_processing?
      inbound_email.delivered? || inbound_email.bounced?
    end

    # Enqueues the given +message+ for delivery and changes the inbound email's status to +:bounced+.
    def bounce_with(message)
      inbound_email.bounced!
      message.deliver_later
    end

    private

    def track_status_of_inbound_email
      inbound_email.processing!
      yield
      inbound_email.delivered! unless inbound_email.bounced?
    rescue StandardError
      inbound_email.failed!
      raise
    end #:nodoc:
  end
end

ActiveSupport.run_load_hooks :action_mailbox, ActionMailbox::Base
