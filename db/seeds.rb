# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# We can use this file to populate the database

# Creates User
# object = {
#   "name": 'John Smith',
#   "email": 'John@gmail.com',
#   "password": 'FakePassword123',
#   "saved_events": [],
#   "created_events": []
# }
# user = User.create(object)

#Create a host 
host_object = {
  "name": "John Smith",
  "email": "fakeemail@gmail.com",
  "password": "fakepassword",
  "password_confirmation": "fakepassword"
}
host_object2 = {
  "name": "John Lu",
  "email": "fakeemail2@gmail.com",
  "password": "fakepassword",
  "password_confirmation": "fakepassword"
}

host = Host.create(host_object)
host.save
host2 = Host.create(host_object2)
host2.save

# Creates Event for host 1
event_object = {
  "title": 'Partyy',
  "description": 'Come party yall',
  "date": '',
  "type_id": '1',
  "latitude": '39.9800',
  "longitude": '-75.1600'
} 

#Creates event for host 2
event_object2 = {
  "title": 'Partyy 2',
  "description": 'Come party yall',
  "date": '',
  "type_id": '1',
  "latitude": '39.9800',
  "longitude": '-75.1600'
}


# Associates the host to this event
host.event.create(event_object)

host2.event.create(event_object2)
