json.extract! event, :id, :title, :description, :start, :end, :user_id, :created_at, :updated_at, :state, :isAllDay
json.url event_url(event, format: :json)
