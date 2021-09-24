module Polycon
  module Commands
    module Professionals
      require 'polycon/models/Professional'
      require 'polycon/helps'
      class Create < Dry::CLI::Command
        desc 'Create a professional'

        argument :name, required: true, desc: 'Full name of the professional'

        def call(name:, **)
          abort("Este profesional ya existe") unless not Dir.exist? name
          Professional.new(name).create
          puts "Profesional creado exitosamente"
          #warn "TODO: Implementar creación de un o una profesional con nombre '#{name}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
        end
      end

      class Delete < Dry::CLI::Command
        desc 'Delete a professional (only if they have no appointments)'

        argument :name, required: true, desc: 'Name of the professional'

        def call(name: )
          abort("Este profesional no existe") unless Dir.exist? name
          professional = Professional.new(name)
          professional.delete
          puts "Profesional eliminado correctamente"
          #warn "TODO: Implementar borrado de la o el profesional con nombre '#{name}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
        end
      end

      class List < Dry::CLI::Command
        desc 'List professionals'

        def call(*)
          Professional.list
          #warn "TODO: Implementar listado de profesionales.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
        end
      end

      class Rename < Dry::CLI::Command
        desc 'Rename a professional'

        argument :old_name, required: true, desc: 'Current name of the professional'
        argument :new_name, required: true, desc: 'New name for the professional'

        example [
          '"Alna Esevez" "Alma Estevez" # Renames the professional "Alna Esevez" to "Alma Estevez"',
        ]

        def call(old_name:, new_name:, **)
          # chequeo que exista el profesional a renombrar
          abort "no existe el profesional #{old_name}" unless Dir.exist? old_name
          # chequeo que NO exista el profesional del nuevo nombre
          abort "no se puede cambiar el nombre de este profesional porque ya existe uno con el nombre #{new_name}" unless not Dir.exist? new_name
          # Si no se aborto por nada de esto, actualizo el nombre
          Professional.new(old_name).rename new_name
          puts "Se actualizo el profesional #{old_name} por #{new_name} "
          #warn "TODO: Implementar renombrado de profesionales con nombre '#{old_name}' para que pase a llamarse '#{new_name}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
        end
      end
    end
  end
end
