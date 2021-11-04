class CreateWorkouts < ActiveRecord::Migration[6.1]
  def change
    create_table :workouts, id: :uuid  do |t|
      t.references :user, type: :uuid
      t.datetime :workout_at
      t.integer :duration

      t.timestamps
    end
  end
end
