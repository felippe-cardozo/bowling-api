class CreateFrame < ActiveRecord::Migration[6.1]
  def change
    create_table :frames, id: :uuid do |t|
      t.uuid      :game_id
      t.integer   :number

      t.timestamps
    end
  end
end
