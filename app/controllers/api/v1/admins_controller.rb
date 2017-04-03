class Api::V1::AdminsController < ApplicationController
  include ControllerUtility
  before_action :authenticate_admin!, only: [:destroy]
  before_action only: [:index,:admins_by_search,:admins_by_ids,:admins_by_not_ids] do
    set_pagination(params)
  end
  before_action :set_admin, only: [:show,:destroy]

  def index
    @admins = Admin.load_admins(admin_pagination.merge(admin_params: params[:admin_params]))
    render json: @admins,status: :ok, each_serializer: Api::V1::AdminSerializer, root: "data",render_attribute: params[:admin_params] || "all"
  end

  def show
    if @admin
      if stale?(@admin,public: true)
        render json: @admin,status: :ok,serializer: Api::V1::AdminSerializer,root: "data", :location => api_v1_admin_path(@admin),render_attribute: params[:admin_params] || "all"
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

  def admins_by_search
    if params.has_key?(:q)
      @admins = Admin.admins_by_search(params[:q],admin_pagination)
      render json: @admins,status: :ok,each_serializer: Api::V1::AdminSerializer,root: "data",render_attribute: params[:admin_params] || "all"
    else
      q_not_found
    end
  end

  def admins_by_ids
    ids = set_ids
    @admins = Admin.admins_by_ids(ids,admin_pagination)
    render json: @admins, status: :ok,each_serializer: Api::V1::AdminSerializer,root: "data",render_attribute: params[:admin_params] || "all"
  end

  def admins_by_not_ids
    ids = set_ids
    @admins = Admin.admins_by_not_ids(ids,admin_pagination)
    render json: @admins, status: :ok,each_serializer: Api::V1::AdminSerializer,root: "data",render_attribute: params[:admin_params] || "all"
  end

  private


    def set_ids
      ids = nil
      if params.has_key?(:admin)
        ids = params[:admin][:ids].split(",")
      end
      ids ||= []
      ids
    end

    def admin_pagination
      {page: @page, per_page: @per_page}
    end

    def set_admin
      @admin = Admin.admin_by_id(params[:id],{admin_params: params[:admin_params]})
    end

end
