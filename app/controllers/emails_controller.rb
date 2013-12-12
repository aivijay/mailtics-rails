class EmailsController < ApplicationController
  respond_to :html,:json
  
  protect_from_forgery :except => [:post_data]
  
  # Don't forget to edit routes if you're using RESTful routing
  # 
  #resources :emails,:only => [:index] do
  #   collection do
  #     post "post_data"
  #   end
  # end

  def post_data
    message=""
    email_params = { :email => paramsp[:email], :last_name => params[:last_name],:first_name => params[:first_name],:id => params[:id],:updated_at => params[:updated_at] }
    case params[:oper]
    when 'add'
      if params["id"] == "_empty"
        email = Email.create(email_params)
        message << ('add ok') if email.errors.empty?
      end
      
    when 'edit'
      #email = Email.find(params[:id])
      email = Subscriber.find(params[:id])
      message << ('update ok') if email.update_attributes(email_params)
    when 'del'
      Email.destroy_all(:id => params[:id].split(","))
      message <<  ('del ok')
    when 'sort'
     # emails = Email.all
     email = Subscriber.all
      emails.each do |email|
        email.position = params['ids'].index(email.id.to_s) + 1 if params['ids'].index(email.id.to_s) 
        email.save
      end
      message << "sort ak"
    else
      message <<  ('unknown action')
    end
    
    unless (email && email.errors).blank?  
      email.errors.entries.each do |error|
        message << "<strong>#{Email.human_attribute_name(error[0])}</strong> : #{error[1]}<br/>"
      end
      render :json =>[false,message]
    else
      render :json => [true,message] 
    end
  end
  
  
  def index
    index_columns ||= [:email,:last_name,:first_name,:id,:updated_at]
    current_page = params[:page] ? params[:page].to_i : 1
    rows_per_page = params[:rows] ? params[:rows].to_i : 10

    conditions={:page => current_page, :per_page => rows_per_page}
    conditions[:order] = params["sidx"] + " " + params["sord"] unless (params[:sidx].blank? || params[:sord].blank?)
    
    if params[:_search] == "true"
      conditions[:conditions]=filter_by_conditions(index_columns)
      logger.warn "debug: ============================>>>> SEARCH -- [" + conditions.to_s + "]"
    end
    
    #@emails=Email.paginate(conditions)
    #@emails = Subscriber.all
    @emails = current_user.subscribers.where(conditions[:conditions]).order(conditions[:order]).paginate(conditions)
    #current_user.subscribers.order("subscribers.updated_at DESC").paginate(:per_page => 20, :page => params[:page])
    total_entries=@emails.total_entries
    #total_entries = @emails.count
    logger.warn "debug: ------------------->>>>>>>>>>>>>>>>>>> FINAL CONDITIONS = [" + conditions.to_s + "]"
    respond_with(@emails) do |format|
      format.json { render :json => @emails.to_jqgrid_json(index_columns, current_page, rows_per_page, total_entries)}  
    end
  end

end
