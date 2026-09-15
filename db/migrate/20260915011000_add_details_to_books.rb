class AddDetailsToBooks < ActiveRecord::Migration[8.1]
  def change
    add_column :books, :author, :string
    add_column :books, :price, :decimal, precision: 10, scale: 2
    add_column :books, :published_date, :date
  end
end
