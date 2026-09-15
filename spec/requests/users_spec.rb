require "rails_helper"

RSpec.describe "Users", type: :request do
  it "creates, lists, edits and deletes a user" do
    post users_path, params: { user: { username: "Tayte" } }
    user = User.last
    expect(response).to redirect_to(user_path(user))
    get users_path
    expect(response.body).to include("Tayte")
    get edit_user_path(user)
    expect(response).to have_http_status(:ok)
    patch user_path(user), params: { user: { username: "Tayte C" } }
    expect(user.reload.username).to eq("Tayte C")
    expect { delete user_path(user) }.to change(User, :count).by(-1)
  end

  it "displays validation errors for a blank username" do
    expect { post users_path, params: { user: { username: "" } } }.not_to change(User, :count)
    expect(response).to have_http_status(:unprocessable_content)
    expect(response.body).to include("Username can&#39;t be blank")
  end
end
