# frozen_string_literal: true

module Polycon
  module Commands
    module Appointments
      require 'polycon/models/Appointment'
      require 'polycon/models/Professional'
      require 'polycon/helps'
      class Create < Dry::CLI::Command
        desc 'Create an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'
        option :name, required: true, desc: "Patient's name"
        option :surname, required: true, desc: "Patient's surname"
        option :phone, required: true, desc: "Patient's phone number"
        option :notes, required: false, desc: 'Additional notes for appointment'

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" --name=Carlos --surname=Carlosi --phone=2213334567'
        ]

        def call(date:, professional:, name:, surname:, phone:, notes: nil)
          abort('No es una fecha valida') unless Help.valid_date_time? date
          Help.professional_existe? professional
          Help.appointment_exist? "#{professional}/#{Help.formato date}.paf"
          Appointment.create_appointment(date, professional, name, surname, phone, notes)
          puts 'Turno creado exitosamente'
        end
      end

      class Show < Dry::CLI::Command
        desc 'Show details for an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" # Shows information for the appointment with Alma Estevez on the specified date and time'
        ]

        def call(date:, professional:)
          abort('No es una fecha valida') unless Help.valid_date_time? date
          Help.professional_existe? professional
          Help.appointment_not_exist? "#{professional}/#{Help.formato date}.paf"
          File.foreach("#{professional}/#{Help.formato date}.paf") { |line| puts line }
        end
      end

      class Cancel < Dry::CLI::Command
        desc 'Cancel an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" # Cancels the appointment with Alma Estevez on the specified date and time'
        ]

        def call(date:, professional:)
          abort('No es una fecha valida') unless Help.valid_date_time? date
          Help.professional_existe? professional
          Help.appointment_not_exist? "#{professional}/#{Help.formato date}.paf"
          File.delete "#{professional}/#{Help.formato date}.paf"
          puts "Turno #{date} cancelado exitosamente"
        end
      end

      class CancelAll < Dry::CLI::Command
        desc 'Cancel all appointments for a professional'

        argument :professional, required: true, desc: 'Full name of the professional'

        example [
          '"Alma Estevez" # Cancels all appointments for professional Alma Estevez'
        ]

        # noinspection RubyArgumentParentheses
        def call(professional:)
          Help.professional_existe? professional
          if Dir.empty? "#{Dir.home}/.polycon/#{professional}/"
            abort("No existen turnos para el profesional #{professional}")
          end
          Dir.foreach("#{Dir.home}/.polycon/#{professional}/") do |f|
            fn = File.join("#{Dir.home}/.polycon/#{professional}/", f)
            File.delete(fn) if f != '.' && f != '..'
          end
          puts "Se eliminaron todos los turnos del profesional #{professional}"
        end
      end

      class List < Dry::CLI::Command
        desc 'List appointments for a professional, optionally filtered by a date'

        argument :professional, required: true, desc: 'Full name of the professional'
        option :date, required: false, desc: 'Date to filter appointments by (should be the day)'

        example [
          '"Alma Estevez" # Lists all appointments for Alma Estevez',
          '"Alma Estevez" --date="2021-09-16" # Lists appointments for Alma Estevez on the specified date'
        ]

        # noinspection RubyArgumentParentheses
        def call(professional:, date:nil)
          if !date.nil?
            abort('No es una fecha valida') unless Help.valid_date? date
          end
          Help.professional_existe? professional
          if Dir.empty? "#{Dir.home}/.polycon/#{professional}/"
            abort("No existen turnos para el profesional #{professional}")
          end
          Dir.each_child("#{Dir.home}/.polycon/#{professional}/") { |file| puts " turno: #{file}" }
        end
      end

      class Reschedule < Dry::CLI::Command
        desc 'Reschedule an appointment'

        argument :old_date, required: true, desc: 'Current date of the appointment'
        argument :new_date, required: true, desc: 'New date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" "2021-09-16 14:00" --professional="Alma Estevez" # Reschedules appointment on the first date for professional Alma Estevez to be now on the second date provided'
        ]

        # noinspection RubyArgumentParentheses
        def call(old_date:, new_date:, professional:)
          abort('No es una fecha valida') unless Help.valid_date_time? old_date
          abort('No es una fecha valida') unless Help.valid_date_time? new_date
          Help.professional_existe? professional
          # Chequeo que exista el turno a renombrar
          Help.appointment_not_exist? "#{professional}/#{Help.formato old_date}.paf"
          # Chequeo que no exista el turno a renombrar
          Help.appointment_exist? "#{professional}/#{Help.formato new_date}.paf"
          File.rename("#{professional}/#{Help.formato old_date}.paf",
                      "#{professional}/#{Help.formato new_date}.paf")
          puts('Turno reprogramado exitosamente')
        end
      end

      class Edit < Dry::CLI::Command
        desc 'Edit information for an appointments'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'
        option :name, required: false, desc: "Patient's name"
        option :surname, required: false, desc: "Patient's surname"
        option :phone, required: false, desc: "Patient's phone number"
        option :notes, required: false, desc: 'Additional notes for appointment'

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" --name="New name" # Only changes the patient\'s name for the specified appointment. The rest of the information remains unchanged.',
          '"2021-09-16 13:00" --professional="Alma Estevez" --name="New name" --surname="New surname" # Changes the patient\'s name and surname for the specified appointment. The rest of the information remains unchanged.',
          '"2021-09-16 13:00" --professional="Alma Estevez" --notes="Some notes for the appointment" # Only changes the notes for the specified appointment. The rest of the information remains unchanged.'
        ]

        def call(date:, professional:, **options)
          abort('No es una fecha valida') unless Help.valid_date_time? date
          Help.professional_existe? professional
          date = Help.formato date
          Help.appointment_not_exist? "#{professional}/#{date}.paf"
          appointment = Appointment.from_file(professional, date)
          appointment.edit(options)
          appointment.save(date)
          puts("El turno #{date} fue editado exitosamente")
        end
      end
    end
  end
end
