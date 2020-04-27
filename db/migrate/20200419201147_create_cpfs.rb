class CreateCpfs < ActiveRecord::Migration[5.2]
  def change
    create_table :cpfs do |t|
      t.string :number

      t.timestamps
    end
  end
end
