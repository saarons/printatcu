class PrintsController < ApplicationController
  before_filter :cache_index, :only => :index
  
  def index
    @print = Print.new

    respond_to do |format|
      format.html
    end
  end
  
  def create
    documents = params[:print].delete(:documents) || []
    params[:print][:copies] = 1 if params[:print][:copies].blank?
    
    @print = Print.new(params[:print])
    @print.user = $redis.rpoplpush("users", "users")
    
    documents.reject(&:blank?).each do |document|
      doc = @print.documents.build
      
      case document
      when String
        doc.url = document
        doc.filename = document
      else
        doc.filename = document.try(:original_filename)
        doc.tempfile = document.try(:tempfile).try(:path)
      end
    end

    respond_to do |format|
      if success = @print.save
        @print.document_ids.each do |id|
          Resque.enqueue(PrintWorker, id)
        end
        
        flash[:user] = @print.user
        flash[:count] = documents.size
        flash[:printer] = @print.printer
        flash[:building] = @print.building
        
        format.html { redirect_to print_path(success: success) }
      else
        format.html { render action: "index" }
      end
    end
  end
  
  private
  def cache_index
    unless params[:success]
      expires_in 30.minutes, :public => true
    end
  end
end
