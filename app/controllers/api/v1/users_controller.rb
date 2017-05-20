class Api::V1::UsersController < ApplicationController
  include ControllerUtility
  devise_token_auth_group :member, contains: [:branch,:admin]
  before_action :authenticate_member!, only: [:destroy]
  before_action :set_user, only: [:show,:destory]
  before_action only: [:index,:male,:female,:users_by_ids,:users_by_not_ids,:users_by_search,:users_by_birthday,:users_with_challenges,:users_with_measurements,:users_with_nutrition_routines,:users_with_workouts] do
    set_pagination(params)
  end

  def index
    if params.has_key?(:branch_id)
      @users = load_users_by_branch(params[:branch_id],user_pagination.merge(user_params: params[:user_params]))
    else
      @users = User.load_users(user_pagination.merge(user_params: params[:user_params]))
    end
    render json: @users,status: :ok,each_serializer: Api::V1::UserSerializer,render_attribute: params[:user_params] ||  "all"
  end

  def show
    if @user
      if stale?(@user,public: true)
        render json: @user,status: :ok,:location => api_v1_user_path(@user), serializer: Api::V1::UserSerializer,render_attribute: params[:user_params] || "all"
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
      @users = User.users_by_male(user_pagination.merge(user_params: params[:user_params]))
        .search_by_branch_id(params[:branch_id])
    else
      @users = User.users_by_male(user_pagination.merge(user_params: params[:user_params]))
    end
    render json: @users,status: :ok,each_serializer: Api::V1::UserSerializer,render_attribute: params[:user_params] || "all"
  end

  def female
    if params.has_key?(:branch_id)
      @users = User.users_by_female(user_pagination.merge(user_params: params[:user_params]))
        .search_by_branch_id(params[:branch_id])
    else
      @users = User.users_by_female(user_pagination.merge(user_params: params[:user_params]))
    end
    render json: @users,status: :ok,each_serializer: Api::V1::UserSerializer,render_attribute: params[:user_params] || "all"
  end

  def users_by_ids
    ids = set_ids
    @users = User.users_by_ids(ids,user_pagination.merge(user_params: params[:user_params]))
    render json: @users,status: :ok, each_serializer: Api::V1::UserSerializer,render_attribute: params[:user_params] || "all"
  end

  def users_by_not_ids
    ids = set_ids
    @users = User.users_by_not_ids(ids,user_pagination.merge(user_params: params[:user_params]))
    render json: @users,status: :ok, each_serializer: Api::V1::UserSerializer,render_attribute: params[:user_params] ||  "all"
  end

  def users_by_search
    if params.has_key?(:q)
      @users = User.users_by_search(params[:q],user_pagination.merge(user_params: params[:user_params]))
      render json: @users, status: :ok,each_serializer: Api::V1::UserSerializer,render_attribute: params[:user_params] || "all"
    else
      q_not_found
    end
  end

  def users_by_birthday
    if params.has_key?(:branch_id)
      @users = User.users_by_birthday(params[:type],user_pagination.merge({year: params[:year],month: params[:month]}).merge(user_params: params[:user_params]))
        .search_by_branch_id(params[:brach_id])
    else
      @users = User.users_by_birthday(params[:type],user_pagination.merge({year: params[:year],month: params[:month]}).merge(user_params: params[:user_params]))
    end
    render json: @users,status: :ok, each_serializer: Api::V1::UserSerializer,render_attribute: params[:user_params] || "all"
  end

  def users_with_challenges
    if params.has_key?(:branch_id)
      @users = User.users_with_challanges(user_pagination.merge(user_params: params[:user_params]))
        .search_by_branch_id(params[:brach_id])
    else
      @users = User.users_with_challanges(user_pagination.merge(user_params: params[:user_params]))
    end
    render json: @users,status: :ok, each_serializer: Api::V1::UserSerializer,render_attribute: params[:user_params] || "all"
  end

  def users_with_measurements
    if params.has_key?(:branch_id)
      @users = User.users_with_measurements(user_pagination.merge(user_params: params[:user_params]))
        .search_by_branch_id(params[:brach_id])
    else
      @users = User.users_with_measurements(user_pagination.merge(user_params: params[:user_params]))
    end
    render json: @users,status: :ok, each_serializer: Api::V1::UserSerializer,render_attribute: params[:user_params] || "all"
  end

  def users_with_nutrition_routines
    if params.has_key?(:branch_id)
      @users = User.users_with_nutrition_routines(user_pagination.merge(user_params: params[:user_params]))
        .search_by_branch_id(params[:branch_id])
    else
      @users = User.users_with_nutrition_routines(user_pagination.merge(user_params: params[:user_params]))
    end
    render json: @users,status: :ok, each_serializer: Api::V1::UserSerializer,render_attribute: params[:user_params] || "all"
  end

  def users_with_workouts
    if params.has_key?(:branch_id)
      @users = User.users_with_workouts(user_pagination.merge(user_params: params[:user_params]))
        .search_by_branch_id(params[:branch_id])
    else
      @users = User.users_with_workouts(user_pagination.merge(user_params: params[:user_params]))
    end
    render json: @users, status: :ok,  each_serializer: Api::V1::UserSerializer,render_attribute: params[:user_params] || "all"
  end

  private
    def set_user
      @user = User.user_by_id(params[:id],{user_params: params[:user_params]})
    end

    def user_pagination
      {page: @page,per_page: @per_page}
    end

    def set_ids
      ids = nil
      if params.has_key?(:user)
        ids = params[:user][:ids].split(",")
      end
      ids ||= []
      ids
    end


end
