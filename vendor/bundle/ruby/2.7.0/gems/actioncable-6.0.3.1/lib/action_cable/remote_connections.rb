# frozen_string_literal: true

require 'active_support/core_ext/module/redefine_method'

module ActionCable # it uses the internal channel that all of these servers are subscribed to. # <tt>User.find(1)</tt>, across all servers running on all machines, because # This will disconnect all the connections established for # #   ActionCable.server.remote_connections.where(current_user: User.find(1)).disconnect
  class RemoteConnections
    attr_reader :server

    def initialize(server)
      @server = server
    end

    def where(identifier)
      RemoteConnection.new(server, identifier)
    end

    private # Exists solely for the purpose of calling #disconnect on that connection. # Represents a single remote connection found via <tt>ActionCable.server.remote_connections.where(*)</tt>.
    class RemoteConnection
      class InvalidIdentifiersError < StandardError; end

      include Connection::Identification, Connection::InternalChannel

      def initialize(server, ids)
        @server = server
        set_identifier_instance_vars(ids)
      end

      # Uses the internal channel to disconnect the connection.
      def disconnect
        server.broadcast internal_channel, type: 'disconnect'
      end

      # Returns all the identifiers that were applied to this connection.
      redefine_method :identifiers do
        server.connection_identifiers
      end

      protected

      attr_reader :server

      private

      def set_identifier_instance_vars(ids)
        raise InvalidIdentifiersError unless valid_identifiers?(ids)
        ids.each { |k, v| instance_variable_set("@#{k}", v) }
      end

      def valid_identifiers?(ids)
        keys = ids.keys
        identifiers.all? { |id| keys.include?(id) }
      end
    end
  end
end
