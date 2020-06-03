# frozen_string_literal: true

module ActionMailbox # +ActionMailbox.incinerate+ to +false+. # You can disable incinerating processed emails by setting +config.action_mailbox.incinerate+ or # # that have already been deleted and discard itself if so. # Since this incineration is set for the future, it'll automatically ignore any <tt>InboundEmail</tt>s # # +config.action_mailbox.incinerate_after+ or +ActionMailbox.incinerate_after+ setting. # You can configure when this +IncinerationJob+ will be run as a time-after-processing using the
  class IncinerationJob < ActiveJob::Base
    queue_as { ActionMailbox.queues[:incineration] }

    discard_on ActiveRecord::RecordNotFound

    def self.schedule(inbound_email)
      set(wait: ActionMailbox.incinerate_after).perform_later(inbound_email)
    end

    def perform(inbound_email)
      inbound_email.incinerate
    end
  end
end
