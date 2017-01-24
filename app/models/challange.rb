class Challange < ApplicationRecord
  before_create :set_state

  default_scope {order("challanges.name ASC")}

  belongs_to :trainer, optional: true
  belongs_to :user

  enum state: {
    :progress => 0,
    :passed => 1,
    :failed => 2
  }

  enum type_challange: {
    :weight_loss => 0,
    :eat_carbohydrates => 1,
    :eat_proteins => 2,
    :eat_fats => 3
  }

  validates :name, :start_date, :end_date, :objective, :type_challange, presence: true
  validates :state, inclusion: {in: states.keys}
  validates :type_challange, inclusion: {in: type_challanges.keys}
  validates :name, length: {minimum: 3}
  validate :valid_date

  protected
  def set_state
    self.state = Challange.states["progress"]
  end

  def valid_date
    if start_date && start_date < Date.today
      errors.add(:start_date, "can't be in the past")
    end
    if start_date && end_date && start_date > end_date
      errors.add(:end_date, "must be greater than start_date")
    end
  end

end
