# frozen_string_literal: true

json.array! @host_events do |event|
    json.title event.title
    json.description event.description
    json.date event.date
    json.location do
      json.longitude event.longitude
      json.latitude event.latitude
    end
    json.host do
      json.name event.host.name
      json.email event.host.email
    end
end