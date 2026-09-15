require "rails_helper"

RSpec.describe UserBook, type: :model do
  it "requires existing parents and rejects duplicate assignments" do
    expect(UserBook.new).not_to be_valid
    user = User.create!(username: "Tayte")
    book = Book.create!(title: "Dune")
    UserBook.create!(user: user, book: book)
    expect(UserBook.new(user: user, book: book)).not_to be_valid
  end

  it "removes joins when a book is deleted while keeping its user" do
    user = User.create!(username: "Tayte")
    book = Book.create!(title: "Dune")
    user.books << book
    expect { book.destroy! }.to change(UserBook, :count).by(-1)
    expect(user.reload.books).to be_empty
  end
end
