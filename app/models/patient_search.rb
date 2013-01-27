class PatientSearch
  include Virtus

  attribute :chart_number,      Integer
  attribute :treatment_area_id, Integer
  attribute :name,              String
  attribute :commit,            String

  def execute
    if blank_search? || commit == 'Clear'
      return reset_attributes && Patient.none
    elsif chart_number.present?
      return Patient.where(id: chart_number)
    end

    patients = Patient.scoped

    if name.present?
      patients = patients.where(
        'first_name ILIKE :name or last_name ILIKE :name', name: "%#{name}%"
      )
    end

    if treatment_area_id.present?
      patients = patients.joins(:treatment_areas).where(
        'treatment_areas.id = ?', treatment_area_id
      )
    end

    patients.order('id')
  end

  def reset_attributes
    attributes.each do |key, value|
      self[key] = nil
    end
  end

  def blank_search?
    attributes.values.all?(&:blank?)
  end
end