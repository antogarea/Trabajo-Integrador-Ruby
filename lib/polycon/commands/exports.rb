module Polycon
  module Commands
    module Exports
      require 'polycon/helps'
      require 'polycon/models/Professional'
      require 'polycon/exports'
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
        #   professional = options[:professional]
        #           puts(professional)
        #           Appointment.transform_to_html(date,professional)


        def call(date:, professional:nil)
          #abort('No es una fecha valida') unless Help.valid_date? date
          #           Help.professional_existe? professional
          #           date = Help.formato date
          #           Help.appointment_not_exist? "#{professional}/#{date}.#{"paf"}"
          if !professional.nil?
            prof = Professional.find_professional(professional)
            if prof.nil?
              warn "El profesional ingresado no existe"
              return 1
            end
          end
          Export.export_appointments_in_day(date, prof)
          puts "La grilla fue creada con éxito, puede encontrarla en el directorio actual: #{Dir.pwd}"
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

