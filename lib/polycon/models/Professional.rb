require 'date'
class Professional
  attr_accessor :name

  def initialize nombre
    self.name =  nombre
  end

  def create
    Dir.mkdir name
  end

  def path
    "#{Help.path}#{name}"
  end

  def delete
    Dir.delete name
  end

  def self.export_all
    Dir.each_child(Help.path) do
    |professional|
      self.new(professional).export_childs
    end
  end

  def self.select_professionals
    professionals = []
    Help.select_professionals.map do |name|
      professionals << new(name)
    end
    professionals
  end

  def appointments(date=nil)
    Help.appointments(self, date).map do |date|
      Appointment.from_file(self, date)
    end
  end


  def export_childs
    Dir.each_child(self.path) do
    |appointment|
      appointmentData = appointment
      appointment = appointment.split()[0]
      Appointment.transform_to_html
    end
  end

  # self.list es un metodo de clase
  def self.list
    Dir.each_child("#{File.join(Dir.home, "/.polycon/")}") { |file| puts "Professional: #{file}" }
  end

  def rename new_name
    FileUtils.mv(name, new_name)
  end

  def self.find_professional(name)
    professional = new(name)
    return professional
  end

  def find_appointment(date)
    appointment = Appointment.new(date, self)
    return Appointment.from_file(self, date)
  end

end
