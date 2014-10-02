class RequestsController < ApplicationController
  before_action :only_owner_can_access, only: [:approve, :deny]
  before_action :owner_cannot_rent_own_cat, only: [:new, :create]

  def new
    @request = CatRentalRequest.new
    render :new
  end

  def create
    @request = CatRentalRequest.new(request_params)
    @request.user_id = current_user.id
    if @request.save
      redirect_to cat_url(@request.cat)
    else
      flash.now[:errors] = @request.errors.full_messages
      render :new
    end
  end

  def index
    @requests = CatRentalRequest.all
    render :index
  end

  def approve
    @request = CatRentalRequest.find(params[:request_id])
    @request.approve!
    redirect_to cat_url(@request.cat)
  end

  def deny
    @request = CatRentalRequest.find(params[:request_id])
    @request.deny!
    redirect_to cat_url(@request.cat)
  end

  # def show
  #   @request = CatRental
  #   render :index
  # end
  # def edit
  #   @cat = Cat.find(params[:id])
  #   render :edit
  # end
  #
  # def update
  #   @cat = Cat.find(params[:id])
  #   if @cat.update(cat_params)
  #     redirect_to cat_url(@cat)
  #   else
  #     flash.now[:errors] = @cat.errors.full_messages
  #     render :edit
  #   end
  # end

  private

  def only_owner_can_access
    @cat = CatRentalRequest.find(params[:request_id]).cat   # DRY?
    redirect_to cat_url(@cat) unless @cat.user_id == current_user.id
  end

  def owner_cannot_rent_own_cat
    @cat = Cat.find(params[:cat_id])   # DRY?
    redirect_to cat_url(@cat) if @cat.user_id == current_user.id
  end

  def request_params
    params.require(:request).permit(:cat_id, :start_date, :end_date)
  end
end
