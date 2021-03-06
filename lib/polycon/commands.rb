# frozen_string_literal: true

module Polycon
  module Commands
    autoload :Professionals, 'polycon/commands/professionals'
    autoload :Appointments, 'polycon/commands/appointments'
    autoload :Version, 'polycon/commands/version'
    autoload :Exports, 'polycon/commands/exports'
    extend Dry::CLI::Registry

    register 'professionals', aliases: ['p'] do |prefix|
      prefix.register 'create', Professionals::Create
      prefix.register 'rename', Professionals::Rename
      prefix.register 'delete', Professionals::Delete
      prefix.register 'list', Professionals::List
    end

    register 'appointments', aliases: ['a'] do |prefix|
      prefix.register 'create', Appointments::Create
      prefix.register 'reschedule', Appointments::Reschedule
      prefix.register 'edit', Appointments::Edit
      prefix.register 'list', Appointments::List
      prefix.register 'show', Appointments::Show
      prefix.register 'cancel', Appointments::Cancel
      prefix.register 'cancel-all', Appointments::CancelAll
    end

    register 'exports', aliases: ['exp'] do |prefix|
      prefix.register 'export-day', Exports::ExportDay
      prefix.register 'export-week', Exports::ExportWeek
    end
    register 'version', Version, aliases: ['v', '-v', '--version']
  end
end
