require "execjs"

class Document < ActiveRecord::Base
  belongs_to :print
  
  attr_protected :filename, :tempfile
  
  before_create :move_file
  
  def convert
    url = "http://printatcu.com/uploads/#{tempfile}"
    response = Excon.get("https://docs.google.com/viewer", :query => {:url => url})
    pdf_url = ExecJS.eval(response.body[/gpUrl:('[^']*')/,1])
    
    if pdf_url
      cookie_jar = Tempfile.new("cookie_jar")
      self.tempfile = converted_tempfile
      output_file = Rails.root.join("public/uploads", tempfile).to_s
      command = ["curl", "-s", "-L", "-c", cookie_jar.path, "-o", output_file, pdf_url]
      puts "Running #{command}"
      IO.popen(command) { |f| puts "curl: #{f.gets}" }
      cookie_jar.close!
      return true
    else
      false
    end
  end
  
  def enqueue
    options = {"HPOption_Duplexer" => "True", "HPOption_2000_Sheet_Tray" => "True", "InstalledMemory" => "128-255MB"}

    options.merge!("sides" => "two-sided-long-edge") if print.double_sided
    options.merge!("Collate" => "True") if print.collate

    options_array = options.map { |k,v| v ? ["-o", "#{k}=#{v}"] : ["-o", "#{k}"] }.flatten

    path = Rails.root.join("public/uploads", tempfile).to_s
    command_array = ["lp", "-c", "-E", "-t", filename, "-d", print.printer, "-U", print.user, "-n", print.copies.to_s].concat(options_array) << "--" << path
    puts "Running #{command_array}"
    IO.popen(command_array) { |f| puts "lp: #{f.gets}" }
  end
  
  def cleanup
    files = [Rails.root.join("public/uploads", tempfile)]
    files << Rails.root.join("public/uploads", tempfile_was) if tempfile_changed?
    
    puts "Cleaning #{files}"
    
    FileUtils.rm files
  end
  
  def converted_tempfile
    self.tempfile.gsub(extension, ".pdf")
  end
  
  def needs_conversion?
    GOOGLE_EXTENSIONS.include?(extension)
  end
  
  def extension
    File.extname(filename).downcase
  end
  
  private
  def move_file
    new_tempfile = SecureRandom.hex(64) + extension
    new_tempfile_path = Rails.root.join("public/uploads", new_tempfile)
    FileUtils.mv(tempfile, new_tempfile_path)
    FileUtils.chmod(0644, new_tempfile_path)
    self.tempfile = new_tempfile
  end
end