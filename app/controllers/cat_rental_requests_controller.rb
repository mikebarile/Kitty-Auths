class CatRentalRequestsController < ApplicationController
  before_action :check_user_id, only: [:approve, :deny]

  def check_user_id
    if current_user.nil?
      redirect_to cats_url
      return
    end
    cat = CatRentalRequest.find(params[:id]).cat
    redirect_to cat_url(cat) unless current_user.id == cat.user_id
  end

  def approve
    current_cat_rental_request.approve!
    redirect_to cat_url(current_cat)
  end

  def create
    all_params = cat_rental_request_params.merge(user_id: current_user.id)
    @rental_request = CatRentalRequest.new(cat_rental_request_params)
    if @rental_request.save
      redirect_to cat_url(@rental_request.cat)
    else
      flash.now[:errors] = @rental_request.errors.full_messages
      render :new
    end
  end

  def deny
    current_cat_rental_request.deny!
    redirect_to cat_url(current_cat)
  end

  def new
    @rental_request = CatRentalRequest.new
  end

  private
  def current_cat_rental_request
    @rental_request ||=
      CatRentalRequest.includes(:cat).find(params[:id])
  end

  def current_cat
    current_cat_rental_request.cat
  end

  def cat_rental_request_params
    params.require(:cat_rental_request)
      .permit(:cat_id, :end_date, :start_date, :status)
  end
end
