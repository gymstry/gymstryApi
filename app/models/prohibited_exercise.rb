class ProhibitedExercise < ApplicationRecord
  belongs_to :exercise
  belongs_to :medical_record
end
