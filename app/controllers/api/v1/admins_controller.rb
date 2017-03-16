class Api::V1::AdminsController < ApplicationController
  include ControllerUtility
  before_action :authenticate_admin!, only: [:destroy]
  before_action only: [:index,:admins_by_name,:admins_by_ids,:admins_by_not_ids] do
    set_pagination(params)
  end
  before_action :set_admin, only: [:show,:destroy]

  def index
    @admins = Admin.load_admins(@page,@per_page)
    render json: @admins,status: :ok
  end

  def show
    if @admin
      if stale?(@admin,public: true)
        render json: @admin,status: :ok, :location => api_v1_admins(@admin)
      end
    else
      record_not_found
    end
  end

  def destroy
    if @admin
      if current_admin.id != @admin.id
        @admin.destroy
        head :no_content
      else
        destroy_not_allowed
      end
    else
      record_not_found
    end
  end

  def admin_by_email
    @admin = Admin.admin_by_email(params[:email] || "")
    if @admin
      if stale?(@admin,public: true)
        render json: @admin,status: :ok
      end
    else
      record_not_found
    end
  end

  def admin_by_username
    @admin = Admin.admin_by_username(params[:username] || "")
    if @admin
      if stale?(@admin,public: true)
        render json: @admin,status: :ok
      end
    else
      record_not_found
    end
  end

  def admins_by_name
    @admins = Admin.admins_by_name(params[:name] || "",@page,@per_page)
    render json: @admins,status: :ok
  end

  def admins_by_ids
    ids = set_ids
    @admins = Admin.admins_by_ids(ids,@page,@per_page)
    render json: @admins, status: :ok
  end

  def admins_by_not_ids
    ids = set_ids
    @admins = Admin.admins_by_not_ids(ids,@page,@per_page)
    render json: @admins, status: :ok
  end

  private
    def set_admin
      @admin = Admin.admin_by_id(params[:id])
    end

    def set_ids
      ids = nil
      if params.has_key?(:admin)
        ids = params[:admin][:ids]
      end
      ids ||= []
      ids
    end

  private
  def set_admin
    @admin = Admin.admins_by_id(params[:id])
  end

end
