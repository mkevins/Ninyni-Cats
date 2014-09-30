class CatsController < ApplicationController
  def index
    @cats = Cat.all
    render :index
  end

  def show
    render json: Cat.find(params[:id])
  end

  private
end
