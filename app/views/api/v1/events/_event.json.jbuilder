json.name event.name
json.start_date event.start_date
json.end_date event.end_date
json.address event.address
json.city event.city
json.country event.country
json.contact_number event.contact_number
json.description event.description
json.logo "#{ request.protocol }#{ request.host_with_port }#{ event.logo.url(:thumb) }"
json.creator do
  json.name  event.user.name
  json.twitter_handle event.user.twitter_name
end
json.number_of_attendees event.attendes.uniq.count
json.number_of_sessions event.sessions.count