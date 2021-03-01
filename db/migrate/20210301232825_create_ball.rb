class CreateBall < ActiveRecord::Migration[6.1]
  def change
    create_table :balls, id: :uuid do |t|
      t.integer :pinfalls
      t.integer :number
      t.uuid    :frame_id

      t.timestamps
    end
  end
end
