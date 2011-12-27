require "execjs"

class Document < ActiveRecord::Base
  belongs_to :print
  
  attr_protected :filename, :tempfile
  
  before_create :move_file
  
  state_machine :status, :initial => :uploaded do    
    event :dispatch do
      transition [:uploaded, :converted] => :printed
    end
    
    after_transition :on => :dispatch do |document, transition|
      options = {"HPOption_Duplexer" => "True", "HPOption_2000_Sheet_Tray" => "True", "InstalledMemory" => "128-255MB"}

      options.merge!("sides" => "two-sided-long-edge") if document.print.double_sided
      options.merge!("Collate" => "True") if document.print.collate

      options_array = options.map { |k,v| v ? ["-o", "#{k}=#{v}"] : ["-o", "#{k}"] }.flatten

      path = Rails.root.join("public/uploads", document.tempfile).to_s
      command_array = ["lp", "-E", "-t", document.filename, "-d", document.print.printer, "-U", document.print.user, "-n", document.print.copies.to_s].concat(options_array) << "--" << path
      puts "Running #{command_array}"
      IO.popen(command_array) { |f| puts "lp: #{f.gets}" }
    end
    
    event :convert do
      transition :uploaded => :converted
    end
    
    after_transition :on => :convert do |document, transition|
      url = "http://printatcu.com/uploads/#{document.tempfile}"
      response = Excon.get("https://docs.google.com/viewer", :query => {:url => url})
      pdf_url = ExecJS.eval(response.body[/gpUrl:('[^']*')/,1])
      cookie_jar = Tempfile.new("cookie_jar")
      output_file = Rails.root.join("public/uploads", document.tempfile).to_s
      command = ["curl", "-s", "-L", "-c", cookie_jar.path, "-o", output_file, pdf_url]
      puts "Running #{command}"
      IO.popen(command) { |f| puts "curl: #{f.gets}" }
      cookie_jar.close!
    end
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