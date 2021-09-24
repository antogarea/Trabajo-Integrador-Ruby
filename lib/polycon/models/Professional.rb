class Professional
  attr_accessor :name

  def initialize nombre
    self.name =  nombre
    #nombre.sub(/A"/, "").sub(/"z/, "")
  end

  def create
    Dir.mkdir name
  end

  def path
    "#{Help.path}#{name}"
  end

  def delete
    Dir.delete name
  end

  # self.list es un metodo de clase
  def self.list
    Dir.each_child("#{File.join(Dir.home, "/.polycon/")}") { |file| puts "Professional: #{file}" }
  end

  def rename new_name
    FileUtils.mv(name, new_name)
  end

end
