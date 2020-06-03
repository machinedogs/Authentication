# frozen_string_literal: true

module ActionCable
  module Channel # You can stop streaming from all broadcasts by calling #stop_all_streams. # #   end #     end #       end #         transmit message # #         end #           logger.info "Message took #{elapsed_time}s to arrive" #           ActiveSupport::Notifications.instrument :performance, measurement: 'Chat.message_delay', value: elapsed_time, action: :timing # #           elapsed_time = (Time.now.to_f - message['originated_at']).round(2) #         if message['originated_at'].present? #       stream_for @room, coder: ActiveSupport::JSON do |message| # #       @room = Chat::Room[params[:room_number]] #     def subscribed #   class ChatChannel < ApplicationCable::Channel # # The below example shows how you can use this to provide performance introspection in the process: # If you don't just want to parlay the broadcast unfiltered to the subscriber, you can also supply a callback that lets you alter what is sent out. # #   CommentsChannel.broadcast_to(@post, @comment) # # You can then broadcast to this channel using: # #   end #     end #       stream_for post #       post = Post.find(params[:id]) #     def subscribed #   class CommentsChannel < ApplicationCable::Channel # # The following example would subscribe to a broadcasting like <tt>comments:Z2lkOi8vVGVzdEFwcC9Qb3N0LzE</tt>. # If you have a stream that is related to a model, then the broadcasting used can be generated from the model and channel. # #   ActionCable.server.broadcast "comments_for_45", author: 'DHH', content: 'Rails is just swell' # # An example broadcasting for this channel looks like so: # # let's say, <tt>comments_for_45</tt> broadcasting as soon as it's put there. # Based on the above example, the subscribers of this channel will get whatever data is put into the, # #   end #     end #       stop_all_streams #     def unfollow # #     end #       stream_from "comments_for_#{data['recording_id']}" #     def follow(data) #   class CommentsChannel < ApplicationCable::Channel # # comments on a given page: # the two parties (the broadcaster and the channel subscriber). Here's an example of a channel that allows subscribers to get all new # Most commonly, the streamed broadcast is sent straight to the subscriber on the client-side. The channel just acts as a connector between # # streaming a broadcasting at the very moment it sends out an update, you will not get that update, even if you connect after it has been sent. # placed into it is automatically sent to the clients that are connected at that time. It's purely an online queue, though. If you're not # Streams allow channels to route broadcastings to the subscriber. A broadcasting is, as discussed elsewhere, a pubsub queue where any data
    module Streams
      extend ActiveSupport::Concern

      included { on_unsubscribe :stop_all_streams }

      # Start streaming from the named <tt>broadcasting</tt> pubsub queue. Optionally, you can pass a <tt>callback</tt> that'll be used
      # instead of the default of just transmitting the updates straight to the subscriber.
      # Pass <tt>coder: ActiveSupport::JSON</tt> to decode messages as JSON before passing to the callback.
      # Defaults to <tt>coder: nil</tt> which does no decoding, passes raw messages.
      def stream_from(broadcasting, callback = nil, coder: nil, &block)
        broadcasting = String(broadcasting)

        # Don't send the confirmation until pubsub#subscribe is successful
        defer_subscription_confirmation!

        # Build a stream handler by wrapping the user-provided callback with
        # a decoder or defaulting to a JSON-decoding retransmitter.
        handler =
          worker_pool_stream_handler(
            broadcasting,
            callback || block,
            coder: coder
          )
        streams << [broadcasting, handler]

        connection.server.event_loop.post do
          pubsub.subscribe(
            broadcasting,
            handler,
            lambda do
              ensure_confirmation_sent
              logger.info "#{self.class.name} is streaming from #{broadcasting}"
            end
          )
        end
      end

      # Start streaming the pubsub queue for the <tt>model</tt> in this channel. Optionally, you can pass a
      # <tt>callback</tt> that'll be used instead of the default of just transmitting the updates straight
      # to the subscriber.
      #
      # Pass <tt>coder: ActiveSupport::JSON</tt> to decode messages as JSON before passing to the callback.
      # Defaults to <tt>coder: nil</tt> which does no decoding, passes raw messages.
      def stream_for(model, callback = nil, coder: nil, &block)
        stream_from(broadcasting_for(model), callback || block, coder: coder)
      end

      # Unsubscribes all streams associated with this channel from the pubsub queue.
      def stop_all_streams
        streams.each do |broadcasting, callback|
          pubsub.unsubscribe broadcasting, callback
          logger.info "#{self.class.name} stopped streaming from #{
                        broadcasting
                      }"
        end.clear
      end

      private

      delegate :pubsub, to: :connection

      def streams
        @_streams ||= []
      end

      # Always wrap the outermost handler to invoke the user handler on the
      # worker pool rather than blocking the event loop.
      def worker_pool_stream_handler(broadcasting, user_handler, coder: nil)
        handler = stream_handler(broadcasting, user_handler, coder: coder)

        lambda do |message|
          connection.worker_pool.async_invoke handler,
                                              :call,
                                              message,
                                              connection: connection
        end
      end

      # May be overridden to add instrumentation, logging, specialized error
      # handling, or other forms of handler decoration.
      #
      # TODO: Tests demonstrating this.
      def stream_handler(broadcasting, user_handler, coder: nil)
        if user_handler
          stream_decoder user_handler, coder: coder
        else
          default_stream_handler broadcasting, coder: coder
        end
      end

      # May be overridden to change the default stream handling behavior
      # which decodes JSON and transmits to the client.
      #
      # TODO: Tests demonstrating this.
      #
      # TODO: Room for optimization. Update transmit API to be coder-aware
      # so we can no-op when pubsub and connection are both JSON-encoded.
      # Then we can skip decode+encode if we're just proxying messages.
      def default_stream_handler(broadcasting, coder:)
        coder ||= ActiveSupport::JSON
        stream_transmitter stream_decoder(coder: coder),
                           broadcasting: broadcasting
      end

      def stream_decoder(handler = identity_handler, coder:)
        if coder
          ->(message) { handler.call(coder.decode(message)) }
        else
          handler
        end
      end

      def stream_transmitter(handler = identity_handler, broadcasting:)
        via = "streamed from #{broadcasting}"

        ->(message) { transmit handler.call(message), via: via }
      end

      def identity_handler
        ->(message) { message }
      end
    end
  end
end
