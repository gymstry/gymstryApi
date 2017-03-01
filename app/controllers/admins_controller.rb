class AdminsController < ApplicationController
  include ControllerUtility
  before_action :authenticate_admin!, only: [:destroy]
  before_action :set_admin, only: [:show,:destroy]
  before_action only: [:index] do
    set_pagination(params)
  end

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


end
