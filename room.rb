class Room

  # def CapacityReachedError < Exception
  # end
  attr_accessor :id

  def initialize(attributes = {})
    @id = attributes[:id]
    @capacity = attributes[:capacity] || 0
    @patients = attributes[:patients] || []
  end

  def full?
    @capacity == @patients.size
  end

  def add_patient(patient)
    fail Exception, "Room is full" if full?
    @patients << patient
    patient.room = self
  end


end

