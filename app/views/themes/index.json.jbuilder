json.array!(@themes) do |theme|
  json.extract! theme, :id, :tenant_id, :font_color
  json.url theme_url(theme, format: :json)
end
