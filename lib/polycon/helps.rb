require 'date'
class Help

  def self.professional_existe? name
    abort("Este profesional no existe: #{name}") unless Dir.exist? name
  end

  def self.appointment_exist? path
    if File.exist? path
      abort("Ya existe el turno con este profesional en ese dia y horario")
    end
  end

  def self.appointment_not_exist? path
    if not File.exist? path
      abort("No existe un turno en ese dia y horario")
    end
  end

  def self.path
    return File.join(Dir.home, "/.polycon/")
  end

  def self.remove(file)
    File.basename file, '.paf'
  end

  def self.formato name
    return  (name.gsub ":", "-").gsub " ", "_"
  end

  def self.valid_date?(date)
    begin
      DateTime.strptime(date, "%Y-%m-%d %H:%M")
      true
    rescue ArgumentError
      false
    end
  end

  def self.select_professionals
    professionals = []
    Dir.foreach("#{Dir.home}/.polycon/") do |professional|
      next if professional == "." or professional == ".."
      professionals << professional
    end
    professionals
  end

  def self.appointments(professional, date=nil)
    appointments = []
    if(not date.nil?)
      Dir.foreach("#{Dir.home}/.polycon/#{professional.name}") do |appointment|
        next if appointment == '.' || appointment == '..'
        appointment = self.remove(appointment)
        dateAppointment = Date.strptime(appointment, '%Y-%m-%d')
        puts(date)
        if (dateAppointment.to_s == date.to_s)
          appointments << appointment
        end
      end
    else
      Dir.foreach("#{Dir.home}/.polycon/#{professional.name}") do |appointment|
        next if appointment == '.' || appointment == '..'
        appointment = self.remove(appointment)
        appointments << appointment
      end
    end
    return appointments
  end
end
