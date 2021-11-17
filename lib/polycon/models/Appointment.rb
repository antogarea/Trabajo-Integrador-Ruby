# frozen_string_literal: true

require 'date'
class Appointment
  attr_accessor :name, :surname, :phone, :notes, :date, :professional

  def initialize(date = nil, professional = nil, name = nil, surname = nil, phone = nil, notes = nil)
    @date = date
    @professional = professional
    @name = name
    @surname = surname
    @phone = phone
    @notes = notes
  end

  def self.create_appointment(date, professional, name, surname, phone, notes = nil)
    date = Help.formato date
    appointment = new(date, professional, name, surname, phone, notes)
    File.open("#{Help.path}/#{appointment.professional}/#{appointment.date}.paf", 'w') do |file|
      file.write("#{appointment.surname}\n#{appointment.name}\n#{appointment.phone}\n#{appointment.notes}")
    end
  end

  def content_appointment
    data = ''
    File.foreach(path('paf')) { |line| data += "#{line}\n" }
    data
  end

  def path(extension)
    "#{professional.path}/#{Help.formato date}.#{extension}"
  end

  def edit(options)
    options.each do |key, value|
      send(:"#{key}=", value)
    end
  end

  def save(date)
    File.open("#{Help.path}/#{professional}/#{date}.paf", 'w') do |file|
      file.write("#{surname}\n#{name}\n#{phone}\n#{notes}")
    end
  end

  def get_date
    date.to_date
  end

  def get_hour
    date.strftime('%H:%M')
  end

  def self.from_file(professional, date)
    appointment = new
    File.open("#{Help.path}/#{professional.name}/#{date}.paf", 'r') do |line|
      appointment.professional = professional
      appointment.date = DateTime.strptime(date, '%Y-%m-%d_%H-%M')
      appointment.surname = line.readline.chomp
      appointment.name = line.readline.chomp
      appointment.phone = line.readline.chomp
      appointment.notes = line.readline.chomp unless line.eof?
    end
    appointment
  end
end
