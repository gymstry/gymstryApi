class Challange < ApplicationRecord
  belongs_to :trainer, optional: true
  belongs_to :user
end
