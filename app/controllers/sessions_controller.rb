class SessionsController < ApplicationController

  def new
    #Форма без обьекта просто говорим на какой url отравить
  end

  def create
    user = User.find_by email: params[:email]
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome to the app, #{current_user.name_or_email}!"
      redirect_to root_path
    else
      flash[:warning] = "Incorrect email and/or password!"
      redirect_to new_session_path
    end
  end

  def destroy

  end
end