require_relative 'room'

class RoomRepository

  attr_accessor :rooms

  def initialize(csv_file_path)
    @csv_file_path = csv_file_path
    @patient_repo = nil
    @rooms = []
    @next_id = 1
    load_csv
  end

  def save_csv
    CSV.open(@csv_file_path, 'wb') do |csv|
      csv << [ "id", "capacity"]
      @rooms.each do |room|
        csv << [ room.id, room.capacity ]
      end
    end
  end

  def find(id)
    @rooms.find {|room| room.id == id }
  end

  def load_csv
    csv_options = { headers: :first_row, header_converters: :symbol }
    CSV.foreach(@csv_file_path, csv_options) do |row|
      row[:id] = row[:id].to_i          # Convert column to Integer
      row[:capacity] = row[:capacity].to_i
      @rooms << Room.new(row)
    end
    @next_id = @rooms.empty? ? 1 : @rooms.last.id + 1
  end
end
