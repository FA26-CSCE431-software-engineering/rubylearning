require "rails_helper"

RSpec.describe "Book attributes", type: :request do
  it "accepts an author through the form and shows the saved author" do
    post books_path, params: { book: { title: "Dune", author: "Frank Herbert" } }
    expect(response).to redirect_to(root_path)
    book = Book.order(:id).last
    expect(book.author).to eq("Frank Herbert")
    get book_path(book)
    expect(response.body).to include("Frank Herbert")
    get edit_book_path(book)
    expect(response.body).to include('value="Frank Herbert"')
  end

  it "accepts a price through the form and shows the saved price" do
    post books_path, params: { book: { title: "Dune", price: "12.95" } }
    expect(response).to redirect_to(root_path)
    book = Book.order(:id).last
    expect(book.price).to eq(BigDecimal("12.95"))
    get book_path(book)
    expect(response.body).to include("12.95")
    get edit_book_path(book)
    expect(response.body).to include('name="book[price]"', 'value="12.95"')
  end

  it "accepts a published date from dropdowns and shows the saved date" do
    post books_path, params: { book: { title: "Dune",
      "published_date(1i)" => "1965", "published_date(2i)" => "8", "published_date(3i)" => "1" } }
    expect(response).to redirect_to(root_path)
    book = Book.order(:id).last
    expect(book.published_date).to eq(Date.new(1965, 8, 1))
    get book_path(book)
    expect(response.body).to include("1965-08-01")
    get edit_book_path(book)
    document = Nokogiri::HTML(response.body)
    expect(document.css('select[name^="book[published_date"]').size).to eq(3)
    expect(document.css("select option[selected]").map { |option| option["value"] })
      .to eq(%w[1965 8 1])
  end
end
