json.array!(@events) do |event|
  json.extract! event, :id, :name, :start_date, :end_date, :start_time, :end_time, :address, :city, :country, :contact_number, :description, :status, :image_url
  json.url event_url(event, format: :json)
end
