require "rails_helper"

RSpec.describe User, type: :model do
  it "requires a username" do
    expect(User.new(username: " ")).not_to be_valid
  end

  it "shares books between users and removes only joins when a user is deleted" do
    first = User.create!(username: "Tayte")
    second = User.create!(username: "Alex")
    book = Book.create!(title: "Dune")
    first.books << book
    second.books << book
    expect(book.users).to contain_exactly(first, second)
    first.destroy!
    expect(book.reload.users).to contain_exactly(second)
  end
end
