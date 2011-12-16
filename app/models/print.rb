require "execjs"

class Print < ActiveRecord::Base
  validates_inclusion_of :double_sided, :collate, :in => [true, false]
  validates_presence_of :building, :printer, :filename, :user, :copies
  validates_numericality_of :copies, :greater_than_or_equal_to => 1, :less_than => 100, :only_integer => true
  
  attr_protected :filename, :tempfile, :user
  
  validate :validate_extension
  
  before_create :move_file
  
  def print
    options = {"HPOption_Duplexer" => "True", "HPOption_2000_Sheet_Tray" => "True", "InstalledMemory" => "128-255MB"}
    
    options.merge!("sides" => "two-sided-long-edge") if double_sided
    options.merge!("Collate" => "True") if collate
    
    options_array = options.map { |k,v| v ? ["-o", "#{k}=#{v}"] : ["-o", "#{k}"] }.flatten
    
    path = Rails.root.join("public/uploads", tempfile).to_s
    command_array = ["lp", "-E", "-t", filename, "-d", printer, "-U", user, "-n", copies.to_s].concat(options_array) << "--" << path
    puts "Running #{command_array}"
    IO.popen(command_array) { |f| puts "lp: #{f.gets}" }
  end
  
  def convert
    url = "http://printatcu.com/uploads/#{tempfile}"
    response = Excon.get("https://docs.google.com/viewer", :query => {:url => url})
    pdf_url = ExecJS.eval(response.body[/gpUrl:('[^']*')/,1])
    cookie_jar = Tempfile.new("cookie_jar")
    output_file = Rails.root.join("public/uploads", tempfile).to_s
    command = ["curl", "-s", "-L", "-c", cookie_jar.path, "-o", output_file, pdf_url]
    puts "Running #{command}"
    IO.popen(command) { |f| puts "curl: #{f.gets}" }
    cookie_jar.close!
    
    return true
  end
  
  def needs_conversion?
    GOOGLE_EXTENSIONS.include?(extension)
  end
  
  private
  def extension
    File.extname(filename).downcase
  end
  
  def validate_extension
    errors.add(:filename, "must end with a valid extension (#{ALL_EXTENSIONS.join(", ")})") unless filename && ALL_EXTENSIONS.include?(extension)
  end
  
  def move_file
    new_tempfile = SecureRandom.hex(64) + extension
    new_tempfile_path = Rails.root.join("public/uploads", new_tempfile)
    FileUtils.mv(tempfile, new_tempfile_path)
    FileUtils.chmod(0644, new_tempfile_path)
    self.tempfile = new_tempfile
  end
end
