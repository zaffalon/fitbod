# frozen_string_literal: true

class UsersController < ApplicationController
    before_action :authenticate, except: [:create]
    load_and_authorize_resource(class: User, id_param: :id, instance_name: :user, except: [:create])
  
    def create
        @user = User.new(users_params)
        if @user.save
            render json: @user, status: :created
        else
            render json: @user.errors, status: :unprocessable_entity
        end
    end

    def show
        render json: @user
    end

    def update
        if @user.update(users_params)
            render json: @user
        end
    end

    private

    def users_params
        params.permit(:email,
                    :password,
                    :password_confirmation,
                    )
    end


end

