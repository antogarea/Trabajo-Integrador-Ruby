require 'date'
class Appointment
  attr_accessor :name, :surname, :phone, :notes, :date, :professional

  def initialize (date=nil, professional=nil, name=nil, surname=nil, phone=nil, notes=nil)
    @date = date
    @professional = professional
    @name = name
    @surname = surname
    @phone = phone
    @notes = notes
  end

  def self.create_appointment(date, professional, name, surname, phone, notes=nil)
    date = Help.formato date
    appointment = new(date, professional, name, surname, phone, notes)
    File.open("#{Dir.home}/.polycon/#{appointment.professional}/#{appointment.date}.paf", "w") {|file| file.write("#{appointment.surname}\n#{appointment.name}\n#{appointment.phone}\n#{appointment.notes}")}

  end

  def content_appointment
    data = ""
    File.foreach(self.path("paf")) {|line| data += line + "\n"}
    data
  end

  def path extension
    "#{profesional.path}/#{turno}.#{extension}"
  end

  def edit(options)
    options.each do |key, value|
      self.send(:"#{key}=", value)
    end
  end

  def save(date)
    File.open("#{Dir.home}/.polycon/#{self.professional}/#{date}.paf", "w") {|file| file.write("#{self.surname}\n#{self.name}\n#{self.phone}\n#{self.notes}")}
  end

  def self.get_date
    return date
  end

  def self.from_file(professional, date)
    appointment = new
    File.open("#{Dir.home}/.polycon/#{professional.name}/#{date}.paf", 'r') do |line|
      appointment.professional = professional
      appointment.date = DateTime.strptime(date, "%Y-%m-%d_%H-%M")
      appointment.surname = line.readline.chomp
      appointment.name = line.readline.chomp
      appointment.phone = line.readline.chomp
      if (!line.eof?)
        appointment.notes = line.readline.chomp
      end
    end
    return appointment
  end

  def self.transform_to_html(date,profesional)
    #markdown = Redcarpet::Markdown.new()
    if not profesional.nil?
      Dir.chdir("#{Dir.home}/.polycon/#{profesional}/")
      path = "#{Help.formato date}.paf"
      puts(path)
      if File.exist? path
        puts('entra')
        data = ""
        File.foreach(path) {|line| data += line + "\n"}
        data
        markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true)
        render = markdown.render(data)
        File.new("#{Help.formato date}.html","w+").write(render)
      end
    end
  end
end
