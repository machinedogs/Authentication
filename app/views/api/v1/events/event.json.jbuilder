json.event do 
    json.title @event.title
    json.description @event.description
    json.date @event.date
    json.location do
      json.longitude @event.longitude
      json.latitude @event.latitude
    end
    json.host do
      json.name @event.host.name
      json.email @event.host.email
    end
end