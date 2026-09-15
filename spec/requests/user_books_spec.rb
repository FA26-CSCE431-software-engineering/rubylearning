require "rails_helper"

RSpec.describe "User Books", type: :request do
  let!(:user) { User.create!(username: "Tayte") }
  let!(:book) { Book.create!(title: "Dune") }

  it "uses existing users and titles in dropdowns" do
    get new_user_book_path
    doc = Nokogiri::HTML(response.body)
    expect(doc.at_css('select[name="user_book[user_id]"]').text).to include("Tayte")
    expect(doc.at_css('select[name="user_book[book_id]"]').text).to include("Dune")
  end

  it "creates, displays, updates and deletes an assignment without deleting its parents" do
    post user_books_path, params: { user_book: { user_id: user.id, book_id: book.id } }
    assignment = UserBook.last
    expect(response).to redirect_to(user_book_path(assignment))
    get root_path
    expect(response.body).to include("User Books", "Tayte", "Dune", "New User Book")
    other = Book.create!(title: "The Hobbit")
    patch user_book_path(assignment), params: { user_book: { book_id: other.id } }
    expect(assignment.reload.book).to eq(other)
    get user_book_path(assignment)
    expect(response.body).to include("The Hobbit")
    expect { delete user_book_path(assignment) }.to change(UserBook, :count).by(-1)
    expect(User.exists?(user.id)).to be true
    expect(Book.exists?(other.id)).to be true
  end

  it "rejects missing and duplicate selections" do
    post user_books_path, params: { user_book: { user_id: "", book_id: book.id } }
    expect(response).to have_http_status(:unprocessable_content)
    UserBook.create!(user: user, book: book)
    expect {
      post user_books_path, params: { user_book: { user_id: user.id, book_id: book.id } }
    }.not_to change(UserBook, :count)
    expect(response).to have_http_status(:unprocessable_content)
  end
end
