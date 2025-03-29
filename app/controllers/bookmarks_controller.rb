class BookmarksController < ApplicationController
  before_action :authenticate_user!

  def create
    @pet = Pet.find(params[:pet_id])
    @bookmark = Bookmark.new(user: current_user, pet: @pet)

    if @bookmark.save
      respond_to do |format|
        format.html { redirect_to pet_path(@pet), notice: "Pet bookmarked!" }
        format.js  # Renders `create.js.erb`
      end
    else
      respond_to do |format|
        format.html { redirect_to pet_path(@pet), alert: "You already bookmarked this pet!" }
        format.js  # Renders `create.js.erb` with an error message (if needed)
      end
    end
  end

  def destroy
    @bookmark = current_user.bookmarks.find(params[:id])
    @bookmark.destroy
    redirect_to user_path(current_user), notice: "Bookmark removed!"
  end
end
