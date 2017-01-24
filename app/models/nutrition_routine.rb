class NutritionRoutine < ApplicationRecord

  default_scope {order("nutrition_routines.name ASC")}

  belongs_to :user
  belongs_to :trainer, optional: true
  has_many :food_days, -> {reorder("food_days.type_food ASC")}, dependent: :destroy

  validates :name, :start_date, :end_date, presence: true
  validates :name, length: {minimum: 3}
  validate :valid_date

  protected
  def valid_date
    if start_date && start_date < Date.today
      errors.add(:start_date, "can't be in the past")
    end
    if start_date && end_date && start_date > end_date
      errors.add(:end_date, "must be greater than start_date")
    end
  end
end
