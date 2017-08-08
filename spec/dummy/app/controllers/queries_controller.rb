class QueriesController < ActionController::Base
  def first
    number.times do
      Item.first
      Post.first
    end

    render plain: ''
  end

  def all
    number.times do
      Item.all.load
      Post.all.load
    end

    render plain: ''
  end

  private

  def number
    params[:id].to_i
  end
end
