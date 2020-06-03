# frozen_string_literal: true

module ActionCable
  module Helpers
    module ActionCableHelper # #   => <meta name="action-cable-url" content="ws://actioncable.com" /> #   <%= action_cable_meta_tag %> would render: #   config.action_cable.url = "ws://actioncable.com" # #   => <meta name="action-cable-url" content="/cable123" /> #   <%= action_cable_meta_tag %> would render: #   config.action_cable.mount_path = "/cable123" # # config files: # Make sure to specify the correct server location in each of your environment # #   App.cable = Cable.createConsumer() #   @App = {} #   #= require cable # # URL directly: # Your CoffeeScript can then connect to the server without needing to specify the # This is then used by Action Cable to determine the URL of your WebSocket server. # #   </head> #     <%= javascript_include_tag 'application', 'data-turbolinks-track' => 'reload' %> #     <%= action_cable_meta_tag %> #   <head> # # configuration. Ensure this is above your JavaScript tag: # Returns an "action-cable-url" meta tag with the value of the URL specified in your
      def action_cable_meta_tag
        tag 'meta',
            name: 'action-cable-url',
            content:
              (
                ActionCable.server.config.url ||
                  ActionCable.server.config.mount_path ||
                  raise(
                    'No Action Cable URL configured -- please configure this at config.action_cable.url'
                  )
              )
      end
    end
  end
end
