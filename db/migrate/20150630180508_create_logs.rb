class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string :sender
      t.string :message
      t.string :status

      t.timestamps null: false
    end
  end
end
