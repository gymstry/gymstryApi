module Utility
  def set_token_resource(resource)
    client_id = SecureRandom.urlsafe_base64(nil, false)
    token     = SecureRandom.urlsafe_base64(nil, false)

    resource.tokens[client_id] = {
      token: BCrypt::Password.create(token),
      expiry: (Time.now + DeviseTokenAuth.token_lifespan).to_i
    }
    new_auth_header = resource.build_auth_header(token, client_id)
    new_auth_header

  end
  def set_range(type,year_number,month_number)
    range = nil
    case type.downcase
      when "today"
        range = today
      when "week"
        range = week
      when "month"
        range = month(year_number,month_number)
      when "year"
        range = year(year_number)
      else
        range = today
    end
    range
  end

  def today
    range = Date.today.beginning_of_day..Date.today.end_of_day
  end

  def week
    today = Date.today
    next_week = Date.today
    if today.monday?
      next_week = (today + 6.days).end_of_day
    else
      today = previous_day(today,1)
      next_week = (today + 6.days).end_of_day
    end
    range = today..next_week
  end

  def month(year,month_number)
    date = Date.new(year,month_number,1).beginning_of_day
    date_end = (date.end_of_month).end_of_day
    range = date..date_end
  end

  def year(year_number)
    date = Date.new(year_number,1,1).beginning_of_day
    date_end = (date.end_of_year).end_of_day
    range = date..date_end
  end

  def previous_day(date,day_of_week)
    date - ((date.wday - day_of_week) % 7)
  end

end
