module ControllerUtility

  def set_pagination(params)
    @page = params[:page]
    @per_page = params[:size]
    @page ||= 1
    @per_page ||= 10
  end

  def record_not_found
    render json: { data: {
        status: "Error",
        error: "We can't find a valid record"
      }
    }, status: :not_found
  end

  def user_not_found
    ender json: {data: {
        status: "Error",
        error: "We can't find a valid user to associate the measurement"
      }
    }
  end

  def resource_not_found
    render json: {data: {
        status: "Error",
        error: "We can't find a valid record to associate the image"
      }
    }
  end

  def user_and_gym
    render json: {data: {
        status: "Error",
        error: "The user doesn't belong to the gym"
      }
    }
  end

  def traniner_and_user
    render json: {data: {
        status: "Error",
        error: "The trainer and the user don't belong to the same branch"
      }
    }
  end

  def nutrition_routine_not_found
    render json: { data: {
        status: "Error",
        error: "The nutrition routine is not valid"
      }
    }
  end

  def foods_needed
    render json: { data: {
        status: "Error",
        error: "The image key is needed"
      }
    }, status: :unprocessable_entity
  end

  def images_needed
    render json: { data: {
        status: "Error",
        error: "The food key is needed"
      }
    }, status: :unprocessable_entity
  end

  def user_needed
    render json: { data: {
        status: "Error",
        error: "The user key is needed"
      }
    }, status: :unprocessable_entity
  end

  def record_error
    render json: { data: {
        status: "Error"
      }
    }, status: :internal_server_error
  end

  def destroy_not_allowed
    render json: {
      data: {
        status: "Error",
        error: "You can't destroy this record"
      }
    }, status: :unauthorized
  end

  def operation_not_allowed
    render json: { data: {
        status: "Error",
        error: "You are not the owner of this record"
      }
    }, status: :unauthorized
  end


  def record_errors(record)
    render json: {data: {
        status: "Error",
        errors: record.errors.to_hash.merge(full_messages: record.errors.full_messages)
      }
    }, status: :unprocessable_entity
  end

end
