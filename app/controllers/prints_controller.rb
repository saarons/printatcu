class PrintsController < ApplicationController
  before_filter :cache_new, :only => :new
  before_filter :sanitize_input, :only => :create
  
  def new
    @print = Print.new
  end
  
  def create    
    @print = Print.new(params[:print])
    @print.user = get_user
    @print.ip = get_ip

    build_documents(@print, params[:documents])

    respond_to do |format|
      if success = @print.save
        @print.enqueue

        set_flash(@print)
        set_cookies(@print)
        
        format.html { redirect_to root_path(success: success) }
      else
        format.html { render action: "new" }
      end
    end
  end
  
  private
  def sanitize_input
    params[:print] ||= {}
    params[:print][:documents] ||= []
    params[:print][:documents].reject!(&:blank?)
    params[:print][:documents].reject! { |d| d == "[]" }
    params[:documents] = params[:print].delete(:documents)
    params[:print][:copies] = 1 if params[:print][:copies].blank?
  end

  def get_user
    $redis.rpoplpush("users", "users") || "Malkovich"
  end

  def get_ip
    request.headers["X-Real-IP"] if Rails.env.production?
  end

  def build_documents(print, documents)
    documents.each do |document|
      doc = print.documents.build
      
      case document
      when String
        doc.url = document
        doc.filename = document
      else
        doc.filename = document.try(:original_filename)
        doc.tempfile = document.try(:tempfile).try(:path)
      end
    end
  end

  def set_flash(print)
    flash[:user]     = print.user
    flash[:printer]  = print.printer
    flash[:building] = print.building
    flash[:count]    = print.documents.size
  end

  def set_cookies(print)
    secure = Rails.env.production?
    domain = if Rails.env.production?
      request.host.split(".")[-2..-1].join(".")
    end
      
    [:printer, :building].each do |x|
      cookies.permanent[x] = {value: print.send(x), secure: secure, domain: domain}
    end
  end
  
  def cache_new
    unless params[:success]
      expires_in 30.minutes, :public => true
    end
  end
end
