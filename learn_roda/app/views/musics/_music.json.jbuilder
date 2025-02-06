json.extract! music, :id, :artist, :title, :tag, :label, :country, :genre, :release_date, :created_at, :updated_at
json.url music_url(music, format: :json)
