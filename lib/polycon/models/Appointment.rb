class Appointment
  attr_accessor :turno, :profesional, :cuerpo

  def initialize date, professional, name, surname, phone, notes
    self.turno = Help.formato date
    self.profesional = professional
    self.cuerpo = "#{surname}\n#{name}\n#{phone.to_s}\n#{notes}"
  end

  def create
    Dir.chdir("#{Dir.home}/.polycon/#{profesional}/") # Me posiciono ahi
    # Creo el archivo al menos que ya exista uno con ese nombre
    File.write("#{self.turno}.paf", "#{self.cuerpo}")
  end

end
