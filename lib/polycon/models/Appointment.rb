class Appointment
  attr_accessor :turno, :profesional, :cuerpo

  def initialize date, professional, name, surname, phone, notes
    self.turno = Help.formato date
    self.profesional = professional
    self.cuerpo = "#{surname}\n#{name}\n#{phone.to_s}\n#{notes}"
  end

  def create
    Dir.chdir("#{Dir.home}/.polycon/#{profesional}/") # Me posiciono ahi
    # Creo el archivo al menos que ya exista uno con ese nombre
    File.write("#{self.turno}.paf", "#{self.cuerpo}")
  end

  def content_appointment
    data = ""
    File.foreach(self.path("paf")) {|line| data += line + "\n"}
    data
  end

  def path extension
    "#{profesional.path}/#{turno}.#{extension}"
  end

  def transform_to_html
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true)
    render = markdown.render(self.content_appointment)
    File.new(self.path("html"),"w+").write(render)
  end

end
