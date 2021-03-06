# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create
    email = params[:session][:email].downcase
    password = params[:session][:password]
    if login(email, password)
      flash[:success] = 'ログインしました'
      redirect_to @user
    else
      flash[:danger] = 'ログインに失敗しました'
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = 'ログアウトしました'
    redirect_to root_url
  end

  private

  def login(email, password)
    @user = User.find_by(email: email)
    if @user&.authenticate(password)
      session[:user_id] = @user.id
      return true
    else
      return false
    end
  end
end
