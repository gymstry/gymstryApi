class Api::V1::UsersController < ApplicationController
  include ControllerUtility
  devise_token_auth_group :member, contains: [:branch,:admin]
  before_action :authenticate_member!, only: [:destroy]
  before_action :set_user, only: [:show,:destory]
  before_action only: [:index,:male,:female,:users_by_ids,:users_by_not_ids,:users_by_name,:users_by_lastname,:users_by_username_or_email,:users_by_birthday,:users_with_challenges,:users_with_measurements,:users_with_nutrition_routines,:users_with_workouts] do
    set_pagination(params)
  end
  def index
    if params.has_key?(:branch_id)
      @users = load_users_by_branch(params[:branch_id],user_pagination)
    else
      @users = User.load_users(user_pagination)
    end
    render json: @users,status: :ok
  end

  def show
    if @user
      if stale?(@user,public: true)
        render json: @user,status: :ok,:location => api_v1_user(@user)
      end
    else
      record_not_found
    end
  end

  def destroy
    if @user
      if current_member.is_a?(Admin)
        @user.destroy
        head :no_content
      elsif current_member.id == @user.branch.id
        @user.destroy
        head :no_content
      else
        destroy_not_allowed
      end
    else
      record_not_found
    end
  end

  def male
    if params.has_key?(:branch_id)
      @users = User.male.paginate(:page => @page,:per_page => @per_page)
        .search_by_branch_id(params[:branch_id])
    else
      @users = User.male.paginate(:page => @page,:per_page => @per_page)
    end
    render json: @users,status: :ok
  end

  def female
    if params.has_key?(:branch_id)
      @users = User.female.paginate(:page => @page,:per_page => @per_page)
        .search_by_branch_id(params[:branch_id])
    else
      @users = User.female.paginate(:page => @page,:per_page => @per_page)
    end
    render json: @users,status: :ok
  end

  def users_by_ids
    ids = set_ids
    @users = User.users_by_ids(ids,user_pagination)
    render json: @users,status: :ok
  end

  def users_by_not_ids
    ids = set_ids
    @users = User.users_by_not_ids(ids,user_pagination)
    render json: @users,status: :ok
  end

  def user_by_email
    @user = User.user_by_email(params[:email] || "")
    if @user
      if stale?(@user,public: true)
        render json: @user,status: :ok
      end
    else
      record_not_found
    end
  end

  def user_by_username
    @user = User.user_by_username(params[:username] || "")
    if @user
      if stale?(@user,public: true)
        render json: @user,status: :ok
      end
    end
  else
    record_not_found
  end

  def users_by_name
    if params.has_key?(:branch_id)
      @users = User.users_by_name(params[:name] || "", user_pagination)
        .search_by_branch_id(params[:branch_id])
    else
      @users = User.users_by_name(params[:name] || "", user_pagination)
    end
    render json: @users,status: :ok
  end

  def users_by_lastname
    if params.has_key?(:branch_id)
      @users = User.users_by_lastname(params[:lastname] || "",user_pagination)
        .seach_by_branch_id(params[:branch_id])
    else
      @users = User.users_by_lastname(params[:lastname] || "",user_pagination)
    end
    render json: @users,status: :ok
  end

  def users_by_username_or_email
    if params.has_key?(:branch_id)
      @users = User.users_by_username_or_email(params[:q] || "", user_pagination)
        .search_by_branch_id(params[:brach_id])
    else
      @users = User.users_by_username_or_email(params[:q] || "", user_pagination)
    end
    render json: @users,status: :ok
  end

  def users_by_birthday
    if params.has_key?(:branch_id)
      @users = User.users_by_birthday(params[:type],user_pagination.merge({year: params[:year],month: params[:month]}))
        .search_by_branch_id(params[:brach_id])
    else
      @users = User.users_by_birthday(params[:type],user_pagination.merge({year: params[:year],month: params[:month]}))
    end
    render json: @users,status: :ok
  end

  def users_with_challenges
    if params.has_key?(:branch_id)
      @users = User.users_with_challanges(user_pagination)
        .search_by_branch_id(params[:brach_id])
    else
      @users = User.users_with_challanges(user_pagination)
    end
    render json: @users,status: :ok
  end

  def users_with_measurements
    if params.has_key?(:branch_id)
      @users = User.users_with_measurements(user_pagination)
        .search_by_branch_id(params[:brach_id])
    else
      @users = User.users_with_measurements(user_pagination)
    end
    render json: @users,status: :ok
  end

  def users_with_nutrition_routines
    if params.has_key?(:branch_id)
      @users = User.users_with_nutrition_routines(user_pagination)
        .search_by_branch_id(params[:branch_id])
    else
      @users = User.users_with_nutrition_routines(user_pagination)
    end
    render json: @users,status: :ok
  end

  def users_with_workouts
    if params.has_key?(:branch_id)
      @users = User.users_with_workouts(user_pagination)
        .search_by_branch_id(params[:branch_id])
    else
      @users = User.users_with_workouts(user_pagination)
    end
  end

  private
    def set_user
      @user = User.user_by_id(params[:id])
    end

    def user_pagination
      {page: @page,per_page: @per_page}
    end

    def set_ids
      ids = nil
      if params.has_key?(:user)
        ids = params[:user][:ids]
      end
      ids ||= []
      ids
    end


end
