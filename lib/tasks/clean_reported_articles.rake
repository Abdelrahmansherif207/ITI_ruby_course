namespace :articles do
  desc "Delete articles with 6 or more reports"
  task clean_reported: :environment do
    articles = Article.heavily_reported
    if articles.any?
      puts "Deleting #{articles.count} articles with 6 or more reports..."
      articles.destroy_all
      puts "Cleanup completed successfully."
    else
      puts "No heavily reported articles found."
    end
  end
end
