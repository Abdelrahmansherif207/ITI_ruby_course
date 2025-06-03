class CreateArticles < ActiveRecord::Migration[8.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :body
      t.references :user, null: false, foreign_key: true
      t.integer :reports_count
      t.string :status

      t.timestamps
    end
  end
end
