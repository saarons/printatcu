class Document < ActiveRecord::Base
  belongs_to :print
  attr_accessor :tempfile

  def fetch
    policy, signature = $filepicker.policy('read')
    response = Excon.get(self.url, query: {policy: policy, signature: signature})

    self.filename = response.headers["X-File-Name"] || "Untitled"

    self.tempfile = Tempfile.new(self.filename, encoding: 'ascii-8bit')
    self.tempfile.write(response.body)
    self.tempfile.close

    save!
  end

  def needs_conversion?
    DIRECT_EXTENSIONS.none? do |extension|
      self.filename.end_with?(extension)
    end
  end
  
  def convert
    policy, signature = $filepicker.policy('read')
    actual_url = "#{self.url}?policy=#{policy}&signature=#{signature}"

    pdf_url = begin
      response = Excon.get("https://docs.google.com/viewer", :query => {:url => actual_url})
      gp_url = response.body[/gpUrl:('[^']*')/,1]
      ExecJS.eval(gp_url) if gp_url.present?
    end

    return false unless pdf_url

    cookie_jar = Tempfile.new("cookie_jar")

    command = ["curl", "-s", "-L", "-c", cookie_jar.path, "-o", self.tempfile.path, pdf_url]

    begin
      IO.popen(command) do |f|
        logger.info command.join(" ")
        logger.info f.gets
      end
    ensure
      cookie_jar.close!
    end

    return true
  end
  
  def enqueue
    options = {
      "HPOption_Duplexer" => "True",
      "InstalledMemory" => "128-255MB",
      "HPOption_2000_Sheet_Tray" => "True"
    }

    options.merge!("Collate" => "True") if print.collate
    options.merge!("sides" => "two-sided-long-edge") if print.double_sided

    options_array = options.map { |k,v| v ? ["-o", "#{k}=#{v}"] : ["-o", "#{k}"] }.flatten

    command = ["lp", "-c", "-t", self.filename.to_s, "-d", print.printer.to_s, "-U", print.user.to_s, "-n", print.copies.to_s].concat(options_array) << "--" << self.tempfile.path

    IO.popen(command) do |f|
      logger.info command.join(" ")
      logger.info f.gets
    end
  end
  
  def announce
    if Rails.env.production?
      json = ActiveSupport::JSON.encode({building: print.building})
      Pusher["printatcu"].trigger("print", json)
    end
  end

  def cleanup
    self.tempfile.unlink

    policy, signature = $filepicker.policy('remove')
    Excon.delete(self.url, query: {policy: policy, signature: signature})
  end
end