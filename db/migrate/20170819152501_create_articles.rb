class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.string :url
      t.boolean :bias

      t.timestamps
    end
  end
end
