set :environment, "development"

every 5.minutes do
  rake "articles:clean_reported"
end
