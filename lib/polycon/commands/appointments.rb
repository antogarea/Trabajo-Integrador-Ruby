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
        option :notes, required: false, desc: "Additional notes for appointment"

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" --name=Carlos --surname=Carlosi --phone=2213334567'
        ]

        def call(date:, professional:, name:, surname:, phone:, notes: nil)
          abort('No es una fecha valida') unless Help.valid_date? date
          Help.professional_existe? professional
          Help.appointment_exist?"#{professional}/#{Help.formato date}.#{"paf"}"
          Appointment.create_appointment(date,professional,name,surname,phone,notes)
          puts "Turno creado exitosamente"
          #warn "TODO: Implementar creación de un turno con fecha '#{date}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
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
          abort('No es una fecha valida') unless Help.valid_date? date
          Help.professional_existe? professional
          Help.appointment_not_exist? "#{professional}/#{Help.formato date}.#{"paf"}"
          File.foreach("#{professional}/#{Help.formato date}.#{"paf"}") {|line| puts line}
          #warn "TODO: Implementar detalles de un turno con fecha '#{date}' y profesional '#{professional}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
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
          abort('No es una fecha valida') unless Help.valid_date? date
          Help.professional_existe? professional
          Help.appointment_not_exist? "#{professional}/#{Help.formato date}.#{"paf"}"
          File.delete "#{professional}/#{Help.formato date}.#{"paf"}"
          puts "Turno #{date} cancelado exitosamente"
          #warn "TODO: Implementar borrado de un turno con fecha '#{date}' y profesional '#{professional}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
        end
      end

      class CancelAll < Dry::CLI::Command
        desc 'Cancel all appointments for a professional'

        argument :professional, required: true, desc: 'Full name of the professional'

        example [
          '"Alma Estevez" # Cancels all appointments for professional Alma Estevez',
        ]

        def call(professional:)
          Help.professional_existe? professional
          abort ("No existen turnos para el profesional #{professional}") unless not Dir.empty? "#{Dir.home}/.polycon/#{professional}/"
          Dir.foreach("#{Dir.home}/.polycon/#{professional}/") do |f|
            fn = File.join("#{Dir.home}/.polycon/#{professional}/", f)
            File.delete(fn) if f != '.' && f != '..'
          end
          puts "Se eliminaron todos los turnos del profesional #{professional}"
          #warn "TODO: Implementar borrado de todos los turnos de la o el profesional '#{professional}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
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

        def call(professional:)
          abort('No es una fecha valida') unless Help.valid_date? date
          Help.professional_existe? professional
          abort ("No existen turnos para el profesional #{professional}") unless not Dir.empty? "#{Dir.home}/.polycon/#{professional}/"
          Dir.each_child("#{Dir.home}/.polycon/#{professional}/"){|file| puts " turno: #{file}"}
          #warn "TODO: Implementar listado de turnos de la o el profesional '#{professional}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
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

        def call(old_date:, new_date:, professional:)
          abort('No es una fecha valida') unless Help.valid_date? old_date
          abort('No es una fecha valida') unless Help.valid_date? new_date
          Help.professional_existe? professional
          #Chequeo que exista el turno a renombrar
          Help.appointment_not_exist? "#{professional}/#{Help.formato old_date}.#{"paf"}"
          #Chequeo que no exista el turno a renombrar
          Help.appointment_exist? "#{professional}/#{Help.formato new_date}.#{"paf"}"
          File.rename("#{professional}/#{Help.formato old_date}.#{"paf"}","#{professional}/#{Help.formato new_date}.#{"paf"}" )
          puts ("Turno reprogramado exitosamente")
          #warn "TODO: Implementar cambio de fecha de turno con fecha '#{old_date}' para que pase a ser '#{new_date}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
        end
      end

      class Edit < Dry::CLI::Command
        desc 'Edit information for an appointments'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'
        option :name, required: false, desc: "Patient's name"
        option :surname, required: false, desc: "Patient's surname"
        option :phone, required: false, desc: "Patient's phone number"
        option :notes, required: false, desc: "Additional notes for appointment"

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" --name="New name" # Only changes the patient\'s name for the specified appointment. The rest of the information remains unchanged.',
          '"2021-09-16 13:00" --professional="Alma Estevez" --name="New name" --surname="New surname" # Changes the patient\'s name and surname for the specified appointment. The rest of the information remains unchanged.',
          '"2021-09-16 13:00" --professional="Alma Estevez" --notes="Some notes for the appointment" # Only changes the notes for the specified appointment. The rest of the information remains unchanged.',
        ]

        def call(date:, professional:, **options)
          abort('No es una fecha valida') unless Help.valid_date? date
          Help.professional_existe? professional
          prof = Professional.find_professional professional
          Help.appointment_not_exist? "#{professional}/#{Help.formato date}.#{"paf"}"
          appointment = prof.find_appointment date
          puts(appointment)

          warn "TODO: Implementar modificación de un turno de la o el profesional '#{professional}' con fecha '#{date}', para cambiarle la siguiente información: #{options}.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
        end
      end

      class ExportDay < Dry::CLI::Command
        desc 'Export grid of appointments(day) for a date. optionally filtered by a professional'

        argument :date, required: true, desc: 'Date to filter appointments by (should be the day)'
        option :professional, required: false, desc: 'Full name of the professional'

        example [
                  '-- appointment: "2021-09-16 10:00" --professional: "Alma Estevez" # Exporta todos los turnos de ese dia para el profesional Alma Estevez',
                ]
        #Appointment
        #Chequear si existe el turno, osea el nombre del archivo
            # En caso que exista vas a agarrar ese path haciendo un new y luego del new el transform_to_html


        def call(date:, **options)

          professional = options[:professional]
          puts(professional)
          Appointment.transform_to_html(date,professional)
        end
      end

      class ExportWeek < Dry::CLI::Command
        desc 'Export appoiments'

        argument :date, required: true, desc: 'Date to filter appointments by (should be the day)'
        option :professional, required: false, desc: 'Full name of the professional'

        example [
                  '-- appointment: "2021-09-16 10:00" --professional: "Alma Estevez"',
                ]

        def call(professional:, date:)

        end
      end
    end
  end
  end