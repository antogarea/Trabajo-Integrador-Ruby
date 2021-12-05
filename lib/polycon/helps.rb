# frozen_string_literal: true

require 'date'
class Help
  def self.professional_existe?(name)
    abort("Este profesional no existe: #{name}") unless Dir.exist? name
  end

  def self.appointment_exist?(path)
    abort('Ya existe el turno con este profesional en ese dia y horario') if File.exist? path
  end

  def self.appointment_not_exist?(path)
    abort('No existe un turno en ese dia y horario') unless File.exist? path
  end

  def self.path
    File.join(Dir.home, '/.polycon/')
  end

  def self.remove(file)
    File.basename file, '.paf'
  end

  def self.formato(name)
    (name.gsub ':', '-').gsub ' ', '_'
  end

  def self.valid_date_time?(date)
    begin
      DateTime.strptime(date, "%Y-%m-%d %H:%M")
      true
    rescue ArgumentError
      false
    end
  end


  def self.valid_date?(date)
    Date.strptime(date, "%Y-%m-%d")
    true
  rescue ArgumentError
    false
  end

  def self.select_professionals
    professionals = []
    Dir.foreach("#{Dir.home}/.polycon/") do |professional|
      next if (professional == '.') || (professional == '..')

      professionals << professional
    end
    professionals
  end

  def self.appointments(professional, date = nil)
    appointments = []
    puts(date)
    if !date.nil?
      Dir.foreach("#{Help.path}/#{professional.name}") do |appointment|
        next if ['.', '..'].include?(appointment)

        appointment = remove(appointment)
        dateAppointment = Date.strptime(appointment, '%Y-%m-%d')
        appointments << appointment if dateAppointment.to_s == date.to_s
      end
    else
      Dir.foreach("#{Help.path}/#{professional.name}") do |appointment|
        next if ['.', '..'].include?(appointment)
        appointment = remove(appointment)
        appointments << appointment
      end
    end
    appointments
  end
end
