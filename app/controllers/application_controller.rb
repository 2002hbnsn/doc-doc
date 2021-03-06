# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def count_users(user)
    @count_followings = user.followings.count
    @count_followers = user.followers.count
    @count_posts = user.posts.count
    @count_liked_books = user.liked_books.count
  end

  def count_books(book)
    @count_liked_users = book.liked_users.count
    @count_posted_users = book.posted_users.count
  end

  private

  def require_user_logged_in
    redirect_to login_url unless logged_in?
  end

  def read(result)
    isbn = result['isbn']
    title = result['title']
    author = result['author']
    sales_date = result['salesDate']
    sales_date = if sales_date.include?('日') && sales_date.include?('月')
                   Date.strptime(sales_date, '%Y年%m月%d日')
                 elsif sales_date.include?('月')
                   Date.strptime(sales_date, '%Y年%m月')
                 else
                   Date.strptime(sales_date, '%Y年')
                 end
    item_price = result['itemPrice']
    item_url = result['itemUrl']
    image_url = result['largeImageUrl'].gsub('?_ex=300x300', '')
    publisher = result['publisherName']

    {
      isbn: isbn,
      title: title,
      author: author,
      sales_date: sales_date,
      item_price: item_price,
      item_url: item_url,
      image_url: image_url,
      publisher: publisher
    }
  end
end
