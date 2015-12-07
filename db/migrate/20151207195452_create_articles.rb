class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.string :url, index: true
      t.date :published_at
      t.text :content

      t.timestamps null: false
    end
  end
end
