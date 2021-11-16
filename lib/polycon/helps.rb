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

  def self.formato name
    return  (name.gsub ":", "-").gsub " ", "_"
  end

  def self.valid_date?(date)
    begin
      date = Date.strptime(date, "%Y-%m-%d")
      true
    rescue ArgumentError
      false
    end
  end
end
