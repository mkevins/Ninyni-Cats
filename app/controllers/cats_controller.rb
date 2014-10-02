class CatsController < ApplicationController
  before_action :require_current_user!
  before_action :maybe_redirect?, only: [:create, :edit]

  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params) # is this needed anymore?
    @cat.user_id = current_user.id

    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
    @cat = Cat.find(params[:id]) # is this needed anymore?
    render :edit
  end

  def update
    @cat = Cat.find(params[:id])
    if @cat.update(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :edit
    end
  end

  private

  def maybe_redirect?
    @cat = Cat.find(params[:id])
    unless @cat.user_id == current_user.id
      flash[:errors] = ["You don't have that permission."]
      redirect_to cats_url
    end
  end

  def cat_params
    params.require(:cat).permit(:name, :birth_date, :color, :sex, :description)
  end
end
