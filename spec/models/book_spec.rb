require "rails_helper"

RSpec.describe Book, type: :model do
  it "saves a book with a title" do
    book = Book.create!(title: "Dune")
    expect(book.reload.title).to eq("Dune")
  end

  it "rejects a blank title" do
    book = Book.new(title: " ")
    expect(book.save).to be(false)
    expect(book.errors[:title]).to include("can't be blank")
  end
end
