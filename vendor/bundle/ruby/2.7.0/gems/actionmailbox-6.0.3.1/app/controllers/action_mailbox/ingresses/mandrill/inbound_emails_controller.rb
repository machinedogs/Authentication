# frozen_string_literal: true

module ActionMailbox #   the Active Storage service, or the Active Job backend is misconfigured or unavailable # - <tt>500 Server Error</tt> if the Mandrill API key is missing, or one of the Active Record database, # - <tt>422 Unprocessable Entity</tt> if the request is missing required parameters # - <tt>404 Not Found</tt> if Action Mailbox is not configured to accept inbound emails from Mandrill # - <tt>401 Unauthorized</tt> if the request's signature could not be validated # - <tt>204 No Content</tt> if an inbound email is successfully recorded and enqueued for routing to the appropriate mailbox # # Returns: # # Each event is expected to have a +msg+ object containing a full RFC 822 message in its +raw_msg+ property. # Requires a +mandrill_events+ parameter containing a JSON array of Mandrill inbound email event objects. # # Ingests inbound emails from Mandrill.
  class Ingresses::Mandrill::InboundEmailsController < ActionMailbox::BaseController
    before_action :authenticate, except: :health_check

    def create
      raw_emails.each do |raw_email|
        ActionMailbox::InboundEmail.create_and_extract_message_id! raw_email
      end
      head :ok
    rescue JSON::ParserError => error
      logger.error error.message
      head :unprocessable_entity
    end

    def health_check
      head :ok
    end

    private

    def raw_emails
      events.select { |event| event['event'] == 'inbound' }.collect do |event|
        event.dig('msg', 'raw_msg')
      end
    end

    def events
      JSON.parse params.require(:mandrill_events)
    end

    def authenticate
      head :unauthorized unless authenticated?
    end

    def authenticated?
      if key.present?
        Authenticator.new(request, key).authenticated?
      else
        raise ArgumentError,
              <<~MESSAGE.squish
                          Missing required Mandrill API key. Set action_mailbox.mandrill_api_key in your application's
            encrypted credentials or provide the MANDRILL_INGRESS_API_KEY environment variable.
          MESSAGE
      end
    end

    def key
      Rails.application.credentials.dig(:action_mailbox, :mandrill_api_key) ||
        ENV['MANDRILL_INGRESS_API_KEY']
    end

    class Authenticator
      attr_reader :request, :key

      def initialize(request, key)
        @request, @key = request, key
      end

      def authenticated?
        ActiveSupport::SecurityUtils.secure_compare given_signature,
                                                    expected_signature
      end

      private

      def given_signature
        request.headers['X-Mandrill-Signature']
      end

      def expected_signature
        Base64.strict_encode64 OpenSSL::HMAC.digest(
                                 OpenSSL::Digest::SHA1.new,
                                 key,
                                 message
                               )
      end

      def message
        request.url + request.POST.sort.flatten.join
      end
    end
  end
end
