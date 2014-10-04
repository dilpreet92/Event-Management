json.array!(@event_sessions) do |event_session|
  json.extract! event_session, :id, :topic, :start_date, :end_date, :start_time, :end_time, :location, :speaker, :status, :event_id
  json.url event_session_url(event_session, format: :json)
end
