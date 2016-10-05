class CatsController < ApplicationController
  before_action :check_user_id, only: [:edit, :update]

  def check_user_id
    if current_user.nil?
      redirect_to cats_url
      return
    end
    cat = current_user.cats.find(params[:id])
    redirect_to cats_url unless current_user.id == cat.user_id
  end

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
    if current_user.nil?
      redirect_to cats_url
      return
    end
    all_params = cat_params.merge({user_id: current_user.id})
    @cat = Cat.new(all_params)
    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
    @cat = current_user.cats.find(params[:id])
    render :edit
  end

  def update
    @cat = current_user.cats.find(params[:id])
    if @cat.update_attributes(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :edit
    end
  end

  private

  def cat_params
    params.require(:cat)
      .permit(:age, :birth_date, :color, :description, :name, :sex)
  end
end
