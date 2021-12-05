# frozen_string_literal: true

require 'erb'
require 'date'
require 'polycon/helps'
require 'polycon/models/Professional'
class Export
  def self.export_appointments_day(date, professional)
    date = Date.strptime(date, '%Y-%m-%d')
    title = "Turnos_del_dia_#{date}"
      if not professional.nil?
        title = "Turnos_del_#{date}_para_#{professional.name}"
      end
    template = ERB.new(File.read("#{Dir.home}/RubymineProjects/Trabajo-Integrador-Ruby/lib/polycon/templates/export_day.html.erb"))
    save_template(template, date, title, appointments_day(date, professional), horas())
  end

  def self.export_appointments_week(professional, date)
    date = first_day(date)
    title = "Turnos_de_la_semana#{date}"
    template = ERB.new(File.read("#{Dir.home}/RubymineProjects/Trabajo-Integrador-Ruby/lib/polycon/templates/export_week.html.erb"))
    save_template(template, date, title, appointments_week(date, professional), self.horas(), self.dates(date))
  end


  def self.appointments_day(date, professional)
    appointments = template(professional)
    appointments.select { |appointment| appointment.get_date == date }
  end

  def self.template(professional)
    appointments = []
    if professional.nil?
      Professional.select_professionals.map do |prof|
        appointments += prof.appointments
      end
    else
      appointments += professional.appointments
    end
    appointments
  end

  def self.horas
    horas = []
    (10..20).each do |i|
      horas << "#{i}:00"
      horas << "#{i}:30"
    end
    horas
  end

  def self.dates(date)
    dates = []
    (1...7).each do
      dates << date
      date = date.next_day
    end
    dates
  end

  def self.first_day(date)
    #Domingo es 0
    if date.wday > 1
      date = date - (date.wday-1)
    else
      if date.wday == 0
        date = date + 1
      end
    end
    date
  end

  def self.appointments_week(date, professional)
    appointments = template(professional)
    appointments.select { |appoinment| (date..date+6).cover? appoinment.get_date }
  end

  def self.save_template(template, date, title, appointments, horas, dates=nil)
    File.open("#{Dir.pwd}/#{title}.html", "w+") {|file| file.write("#{template.result binding}")}
  end
end
