# frozen_string_literal: true

require 'mail'

module ActionMailbox #   inbound_email.source # Returns the full rfc822 source of the email as text #   inbound_email.mail.from # => 'david@loudthinking.com' # # Examples: # # using the +#source+ method. # which is available as a +Mail+ object from +#mail+. But you can also access the raw source directly # When working with an +InboundEmail+, you'll usually interact with the parsed version of the source, # # automatic incineration at a later point. # it'll count as having been +#processed?+. Once processed, the +InboundEmail+ will be scheduled for # Once the +InboundEmail+ has reached the status of being either +delivered+, +failed+, or +bounced+, # # * Bounced: Rejected processing by the specific mailbox and bounced to sender. # * Failed: An exception was raised during the specific mailbox's execution of the +#process+ method. # * Delivered: Successfully processed by the specific mailbox. # * Processing: During active processing, while a specific mailbox is running its #process method. # * Pending: Just received by one of the ingress controllers and scheduled for routing. # # and tracks the status of processing. By default, incoming emails will go through the following lifecycle: # The +InboundEmail+ is an Active Record that keeps a reference to the raw email stored in Active Storage
  class InboundEmail < ActiveRecord::Base
    self.table_name = 'action_mailbox_inbound_emails'

    include Incineratable, MessageId, Routable

    has_one_attached :raw_email
    enum status: %i[pending processing delivered failed bounced]

    def mail
      @mail ||= Mail.from_source(source)
    end

    def source
      @source ||= raw_email.download
    end

    def processed?
      delivered? || failed? || bounced?
    end
  end
end

ActiveSupport.run_load_hooks :action_mailbox_inbound_email,
                             ActionMailbox::InboundEmail
