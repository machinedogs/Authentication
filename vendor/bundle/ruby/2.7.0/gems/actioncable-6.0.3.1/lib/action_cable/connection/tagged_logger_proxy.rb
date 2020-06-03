# frozen_string_literal: true

module ActionCable
  module Connection # The connection is long-lived, so it needs its own set of tags for its independent duration. # <tt>ActiveSupport::TaggedLogging</tt> enhanced Rails.logger, as that logger will reset the tags between requests. # Allows the use of per-connection tags against the server logger. This wouldn't work using the traditional
    class TaggedLoggerProxy
      attr_reader :tags

      def initialize(logger, tags:)
        @logger = logger
        @tags = tags.flatten
      end

      def add_tags(*tags)
        @tags += tags.flatten
        @tags = @tags.uniq
      end

      def tag(logger)
        if logger.respond_to?(:tagged)
          current_tags = tags - logger.formatter.current_tags
          logger.tagged(*current_tags) { yield }
        else
          yield
        end
      end

      %i[debug info warn error fatal unknown].each do |severity|
        define_method(severity) { |message| log severity, message }
      end

      private

      def log(type, message)
        # :doc:
        tag(@logger) { @logger.send type, message }
      end
    end
  end
end
