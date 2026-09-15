require "rails_helper"

RSpec.describe "Updating books", type: :request do
  it "updates all details and displays the success flash" do
    book = Book.create!(title: "Dune")
    patch book_path(book), params: { book: { title: "Dune Messiah", author: "Frank Herbert",
      price: "15.50", "published_date(1i)" => "1969", "published_date(2i)" => "10", "published_date(3i)" => "15" } }
    expect(response).to redirect_to(root_path)
    expect(book.reload.attributes.slice("title", "author", "price", "published_date"))
      .to eq("title" => "Dune Messiah", "author" => "Frank Herbert",
        "price" => BigDecimal("15.50"), "published_date" => Date.new(1969, 10, 15))
    follow_redirect!
    expect(response.body).to include("Book was successfully updated.", "Dune Messiah", "Frank Herbert", "15.50", "1969-10-15")
  end

  it "keeps saved details when an update has a blank title" do
    book = Book.create!(title: "Dune", author: "Frank Herbert")
    patch book_path(book), params: { book: { title: "", author: "Changed" } }
    expect(response).to have_http_status(422)
    expect(flash[:alert]).to eq("Book could not be saved.")
    expect(book.reload.author).to eq("Frank Herbert")
    expect(book.title).to eq("Dune")
  end

  it "rejects a nonnumeric price without saving a book" do
    expect { post books_path, params: { book: { title: "Dune", price: "abc" } } }
      .not_to change(Book, :count)
    expect(response).to have_http_status(422)
    expect(response.body).to include("Price is not a number", "Book could not be saved.")
  end
end
