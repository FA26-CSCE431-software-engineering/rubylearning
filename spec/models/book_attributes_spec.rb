require "rails_helper"

RSpec.describe Book, type: :model do
  it "persists the author as text" do
    book = Book.create!(title: "Dune", author: "Frank Herbert")
    expect(book.reload.author).to eq("Frank Herbert")
  end

  it "persists an exact decimal price" do
    book = Book.create!(title: "Dune", price: "12.95")
    expect(book.reload.price).to eq(BigDecimal("12.95"))
  end

  it "persists the published date" do
    book = Book.create!(title: "Dune", published_date: Date.new(1965, 8, 1))
    expect(book.reload.published_date).to eq(Date.new(1965, 8, 1))
  end
end
