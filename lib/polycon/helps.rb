class Help

  def self.professional_existe? name
    abort("Este profesional no existe: #{name}") unless Dir.exist? name
  end

  def self.path
    return File.join(Dir.home, "/.polycon/")
  end

end
