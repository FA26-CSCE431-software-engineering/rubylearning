class BooksController < ApplicationController
  before_action :set_book, only: %i[show edit update delete destroy]

  def index
    @books = Book.order(:id)
  end

  def show
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to root_path, notice: "Book was successfully created."
    else
      flash.now[:alert] = "Book could not be saved."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @book.update(book_params)
      redirect_to root_path, notice: "Book was successfully updated.", status: :see_other
    else
      flash.now[:alert] = "Book could not be saved."
      render :edit, status: :unprocessable_entity
    end
  end

  def delete
  end

  def destroy
    @book.destroy!
    redirect_to root_path, notice: "Book was successfully deleted.", status: :see_other
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :author, :price, :published_date)
  end
end
