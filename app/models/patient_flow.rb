class PatientFlow < ActiveRecord::Base
  belongs_to :patient
  belongs_to :treatment_area

  
end
