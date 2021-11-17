# frozen_string_literal: true

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
          '"2021-11-11""',
          '"2021-11-11" --professional="Alma Estevez" "'
        ]

        def call(date:, professional: nil)
          Help.valid_date? date
          unless professional.nil?
            prof = Professional.find_professional(professional)
            Help.professional_existe? prof.name
          end
          if Dir.empty? "#{Dir.home}/.polycon/#{professional}/"
            abort("No existen turnos para el profesional #{professional}")
          end
          Export.export_appointments_in_day(date, prof)
          puts "La grilla fue creada con éxito en #{Dir.pwd}"
        end
      end

      class ExportWeek < Dry::CLI::Command
        desc 'Export appoiments'

        argument :date, required: true, desc: 'Date to filter appointments by (should be the day)'
        option :professional, required: false, desc: 'Full name of the professional'

        example [
          '-- appointment: "2021-09-16 10:00" --professional: "Alma Estevez"'
        ]

        def call(professional:, date:)
          @date = date
          @professional = professional
        end
      end
    end
  end
end
