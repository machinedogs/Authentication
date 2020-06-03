# frozen_string_literal: true

module ActionCable
  module Server #       new Notification data['title'], body: data['body'] #     received: (data) -> #   App.cable.subscriptions.create "WebNotificationsChannel", #   # Client-side CoffeeScript, which assumes you've already requested the right to send web notifications: # #     "web_notifications_1", { title: "New things!", body: "All that's fit for print" } #   ActionCable.server.broadcast \ #   # Somewhere in your app this is called, perhaps from a NewCommentJob: # #   end #     end #       stream_from "web_notifications_#{current_user.id}" #     def subscribed #   class WebNotificationsChannel < ApplicationCable::Channel # # broadcastings are streamed directly to the clients subscribed to the named broadcasting. Let's explain with a full-stack example: # Broadcasting is how other parts of your application can send messages to a channel's subscribers. As explained in Channel, most of the time, these
    module Broadcasting # Broadcast a hash directly to a named <tt>broadcasting</tt>. This will later be JSON encoded.
      def broadcast(broadcasting, message, coder: ActiveSupport::JSON)
        broadcaster_for(broadcasting, coder: coder).broadcast(message)
      end

      # Returns a broadcaster for a named <tt>broadcasting</tt> that can be reused. Useful when you have an object that
      # may need multiple spots to transmit to a specific broadcasting over and over.
      def broadcaster_for(broadcasting, coder: ActiveSupport::JSON)
        Broadcaster.new(self, String(broadcasting), coder: coder)
      end

      private

      class Broadcaster
        attr_reader :server, :broadcasting, :coder

        def initialize(server, broadcasting, coder:)
          @server, @broadcasting, @coder = server, broadcasting, coder
        end

        def broadcast(message)
          server.logger.debug "[ActionCable] Broadcasting to #{broadcasting}: #{
                                message.inspect
                              }"

          payload = {
            broadcasting: broadcasting, message: message, coder: coder
          }
          ActiveSupport::Notifications.instrument(
            'broadcast.action_cable',
            payload
          ) do
            encoded = coder ? coder.encode(message) : message
            server.pubsub.broadcast broadcasting, encoded
          end
        end
      end
    end
  end
end
