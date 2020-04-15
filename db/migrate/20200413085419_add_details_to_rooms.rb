class AddDetailsToRooms < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :order, :string
    add_column :rooms, :client_email, :string
    add_column :rooms, :document, :string
    add_column :rooms, :phone, :string
  end
end
