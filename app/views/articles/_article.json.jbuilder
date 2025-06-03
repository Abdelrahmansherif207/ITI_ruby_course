json.extract! article, :id, :title, :body, :user_id, :image, :reports_count, :status, :created_at, :updated_at
json.url article_url(article, format: :json)
json.image url_for(article.image)
