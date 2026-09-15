require "rails_helper"

RSpec.describe "Creating books", type: :request do
  it "saves a title and displays a success flash" do
    expect { post books_path, params: { book: { title: "Dune" } } }
      .to change(Book, :count).by(1)
    expect(Book.order(:id).last.title).to eq("Dune")
    expect(response).to redirect_to(root_path)
    follow_redirect!
    expect(response.body).to include("Book was successfully created.")
  end

  it "rejects a blank title and displays an error flash" do
    expect { post books_path, params: { book: { title: " " } } }
      .not_to change(Book, :count)
    expect(response).to have_http_status(:unprocessable_entity)
    expect(flash[:alert]).to eq("Book could not be saved.")
    expect(response.body).to include("Book could not be saved.", "Title can&#39;t be blank")
  end
end
