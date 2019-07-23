require 'csv'
require 'patient'

class PatientRepository

  attr_reader :patients

  def initialize(csv_file_path, room_repository)
    @csv_file_path = csv_file_path
    @room_repository = room_repository
    @patients = []
    @next_id = 1
    load_csv
  end

  def add_patient(patient)
    patient.id = @next_id
    @patients << patient
    @next_id += 1
    save_csv
  end


  def save_csv
    CSV.open(@csv_file_path, 'wb') do |csv|
      csv << [ "id", "name", "cured", "room_id"]
      @patients.each do |patient|
        csv << [ patient.id, patient.name, patient.cured, patient.room&.id ]
      end
    end
  end

  def load_csv
    csv_options = { headers: :first_row, header_converters: :symbol }
    CSV.foreach(@csv_file_path, csv_options) do |row|
      row[:id]    = row[:id].to_i          # Convert column to Integer
      row[:cured] = row[:cured] == "true"
      room = @room_repository.find(row[:room_id].to_i)
      patient = Patient.new(row)
      patient.room = room # Convert column to boolean
      @patients << patient
      p patient
    end
    @next_id = @patients.empty? ? 1 : @patients.last.id + 1
  end
end



