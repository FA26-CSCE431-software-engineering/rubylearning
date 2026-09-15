require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @book = Book.create!(title: "The Hobbit")
  end

  test "all pages render with navigation and the current title" do
    get root_url
    assert_response :success
    assert_select "a[href=?]", new_book_path
    [ new_book_path, edit_book_path(@book), book_path(@book), delete_book_path(@book) ].each do |path|
      get path
      assert_response :success
      assert_select "a[href=?]", root_path
    end
    get edit_book_path(@book)
    assert_select "input[name=?][value=?]", "book[title]", @book.title
  end

  test "create update and delete persist and show notices on home" do
    assert_difference("Book.count", 1) { post books_url, params: { book: { title: "Dune" } } }
    assert_redirected_to root_url
    follow_redirect!
    assert_select "[role=status]", "Book was successfully created."
    book = Book.order(:id).last
    patch book_url(book), params: { book: { title: "Dune Messiah" } }
    assert_redirected_to root_url
    assert_equal "Dune Messiah", book.reload.title
    follow_redirect!
    assert_select "[role=status]", "Book was successfully updated."
    assert_no_difference("Book.count") { get delete_book_url(book) }
    assert_difference("Book.count", -1) { delete book_url(book) }
    assert_redirected_to root_url
    follow_redirect!
    assert_select "[role=status]", "Book was successfully deleted."
  end

  test "blank title is rejected without losing an existing book" do
    assert_no_difference("Book.count") { post books_url, params: { book: { title: " " } } }
    assert_response :unprocessable_entity
    assert_select "[role=alert]"
    patch book_url(@book), params: { book: { title: "" } }
    assert_response :unprocessable_entity
    assert_equal "The Hobbit", @book.reload.title
  end
end
