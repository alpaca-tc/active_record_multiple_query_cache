class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table(:items)
    create_table(:posts)
  end
end
