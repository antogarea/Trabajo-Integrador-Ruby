require 'erb'
require 'date'
require 'polycon/helps'
require 'polycon/models/Professional'
  class Export
    def self.export_appointments_in_day(date, professional)
      date = Date.strptime(date, "%Y-%m-%d")
      title = "Turnos_del_dia#{date}"
      template = ERB.new(File.read("#{Dir.home}/RubymineProjects/Trabajo-Integrador-Ruby/lib/polycon/templates/export_day.html.erb"))
      save_template(template, date, title, appointments_day(date, professional), horas())
    end

    def self.appointments_day(date, professional)
      appointments = template(professional)
      appointments.select { |appointment| appointment.date == date }
    end

    def self.template(professional)
      appointments = []
      if professional.nil?
        Professional.select_professionals.map do |prof|
          appointments += prof.appointments()
        end
      else
        appointments += professional.appointments()
      end
      return appointments
    end

    def self.horas()
      horas = []
      for i in 10..20 do
        horas << "#{i}:00"
        horas << "#{i}:30"
      end
      return horas
    end

    def self.save_template(template, date, title, appointments, horas, dates=nil)
      File.open("#{Dir.pwd}/Turnos_del#{date}.html", "w+") {|file| file.write("#{template.result binding}")}
    end
  end
