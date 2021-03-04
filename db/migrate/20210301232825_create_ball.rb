class CreateBall < ActiveRecord::Migration[6.1]
  def change
    create_table :balls, id: :uuid do |t|
      t.integer :pinfalls, null: false
      t.integer :number, null: false
      t.uuid    :frame_id, null: false
      

      t.timestamps
    end
    add_index(:balls, [:frame_id, :number], unique: true)
  end
end
