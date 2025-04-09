class ChatroomsController < ApplicationController
  before_action :set_user, only: %i[index provider_info]
  before_action :set_chatroom, only: :provider_info

  skip_after_action :verify_policy_scoped
  skip_after_action :verify_authorized
  def index
    if params[:user_id].to_i != current_user.id
      render file: Rails.root.join('public', '404.html'), status: :not_found,
             layout: false
    end

    @chatrooms = current_user.chatrooms
    @chatroom = @chatrooms.find_by(id: params[:chatroom_id])
    return unless @chatroom.present?

    @message = @chatroom.messages.new
  end

  def create_chatroom # rubocop:disable Metrics/MethodLength
    @pet = Pet.find(params[:pet_id])
    @provider = @pet.provider
    @adopter = current_user

    existing_chatroom = Chatroom.joins(:users)
                                .where(pet: @pet)
                                .where(users: { id: [@provider.id, @adopter.id] })
                                .group("chatrooms.id")
                                .having("COUNT(users.id) = 2")
                                .first
    if existing_chatroom
      redirect_to user_chatrooms_path(@adopter), notice: "You already messaged that pet."
      return
    end

    @chatroom ||= Chatroom.create(
      name: "Chatroom between #{@provider.first_name || 'unknown'} and #{@adopter.first_name || 'unknown'}",
      pet: @pet
    )

    @chatroom.messages.find_or_create_by(user: @provider) do |msg|
      msg.content = "You have reached #{@provider.first_name}, the owner of #{@pet.name}."
    end

    @message = @chatroom.messages.create(
      content: params[:message][:content],
      user: @adopter
    )

    if @message.save
      redirect_to user_chatrooms_path(@adopter), notice: "Chatroom and message created successfully!"
    else
      flash[:error] = "Message creation failed!"
    end
  end

  def provider_info # rubocop:disable Metrics/MethodLength
    return render json: { error: "Chatroom not found" }, status: 404 unless @chatroom

    @provider = @chatroom.users.where.not(id: current_user.id).first

    if @provider
      profile_url = view_context.user_path(@provider)
      pet_url = view_context.user_pet_path(@provider.id, @chatroom.pet)
      image_url = if @provider.photo.attached?
                    view_context.cl_image_path(@provider.photo.key, width: 50, height: 50, crop: :thumb,
                                                                    gravity: :face)
                  else
                    view_context.asset_url("logo_paw_print.png")
                  end
      render json: {
        name: @provider.first_name,
        pet_name: @chatroom.pet.name,
        image_url: image_url,
        profile_url: profile_url,
        pet_url: pet_url
      }
    else
      render json: { error: "Provider not found" }, status: 404
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_pet
    @pet = Pet.find(params[:pet_id])
  end

  def set_chatroom
    @chatroom = Chatroom.find(params[:id])
  end
end
