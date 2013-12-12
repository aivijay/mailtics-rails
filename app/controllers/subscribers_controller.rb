require 'fastercsv'

class SubscribersController < ApplicationController
  respond_to :html,:xml,:json

  def post_data
    message=""
    subscriber_params = { :email => params[:email], :last_name => params[:last_name],:first_name => params[:first_name],:id => params[:id],:updated_at => params[:updated_at] }
    case params[:oper]
    when 'add'
      if params["id"] == "_empty"
        subscriber = Contact.create(subscriber_params)
        message << ('add ok') if subscriber.errors.empty?
      end

    when 'edit'
      #email = Email.find(params[:id])
      subscriber = Subscriber.find(params[:id])
      message << ('update ok') if subscriber.update_attributes(subscriber_params)
    when 'del'
      Email.destroy_all(:id => params[:id].split(","))
      message <<  ('del ok')
    when 'sort'
     # emails = Email.all
     subscribers = current_user.subscribers
      subscribers.each do |subscriber|
        subscriber.position = params['ids'].index(subscriber.id.to_s) + 1 if params['ids'].index(subscriber.id.to_s)
        subscriber.save
      end
      message << "sort ak"
    else
      message <<  ('unknown action')
    end

    unless (subscriber && subscriber.errors).blank?
      subscriber.errors.entries.each do |error|
        message << "<strong>#{Subscriber.human_attribute_name(error[0])}</strong> : #{error[1]}<br/>"
      end
      render :json =>[false,message]
    else
      render :json => [true,message]
    end
  end


  # Upload subscriber from file (just load the form)
  def upload
    @contact_lists_count = current_user.contacts.count
  end

  # do the actual importing of the file
  def import
    table = ImportTable.new :original_path => params[:upload][:csv].original_path
    row_index = 0
     FasterCSV.parse(params[:upload][:csv]) do |cells|
      column_index = 0
      cells.each do |cell|
        table.import_cells.build :column_index => column_index, :row_index => row_index, :contents => cell
        column_index += 1
      end
      row_index += 1
    end
    table.save
    redirect_to import_table_path(table)

  end
  def poop 
    puts "debug: =============================================================================================> "
  end

  # GET /subscribers
  # GET /subscribers.xml
  def index
    #@subscribers = Subscriber.all

    index_columns ||= [:status_image,:email,:last_name,:first_name,:id,:updated_at]
    current_page = params[:page] ? params[:page].to_i : 1
    rows_per_page = params[:rows] ? params[:rows].to_i : 10

    conditions={:page => current_page, :per_page => rows_per_page}
    conditions[:order] = params["sidx"] + " " + params["sord"] unless (params[:sidx].blank? || params[:sord].blank?)
    
    if params[:_search] == "true"
      conditions[:conditions]=filter_by_conditions(index_columns)
    end
    
    @subscribers = current_user.subscribers.where(conditions[:conditions]).order(conditions[:order]).paginate(conditions)
    total_entries=@subscribers.total_entries
    @total = total_entries

    count = @subscribers.count - 1
    for i in 0..count
      email = @subscribers[i].email
      #@subscribers[i].email = "<b><a>"+ email +"</a></b>"
    
      id = @subscribers[i].id.to_s
      @subscribers[i].email = '<h3 class="dlink"><a href="/subscribers/' + id + '" style="color: #00008d;">' + email + '</a><span class="actions">  <a href="/subscribers/' + id + '/edit">Edit</a>  <a href="/subscribers/' + id + '" data-confirm="Are you sure?" data-method="delete" rel="nofollow">Delete</a></span></h3>'

#      @contacts[i].status = status 
    end

    respond_with(@subscribers) do |format|
      format.json { render :json => @subscribers.to_jqgrid_json(index_columns, current_page, rows_per_page, total_entries)}  
    end



    #@contacts = Contact.all

    @contact_lists_count = current_user.contacts.count
    @total = current_user.subscribers.count


#    @subscribers = current_user.subscribers.order("subscribers.updated_at DESC").paginate(:per_page => 20, :page => params[:page])

#    logger.warn "debug: ------------>>>>>>>> contact_lists_count = [" + @contact_lists_count.to_s + "]"

    #    @result_rules = ResultRule.order("result_rules.created_at DESC, result_rules.rule_id ASC").paginate(:per_page => 20, :page => params[:page])
    # <!--<%= will_paginate @result_rules %>--> -- copy this and use this in the view along with the render


#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @subscribers }
#      format.json  { render :json => @subscribers }
#    end
  end

  # GET /subscribers/1
  # GET /subscribers/1.xml
  def show
    @subscriber = Subscriber.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @subscriber }
    end
  end

  # GET /subscribers/new
  # GET /subscribers/new.xml
  def new
    @subscriber = Subscriber.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @subscriber }
    end
  end

  # GET /subscribers/1/edit
  def edit
    @subscriber = Subscriber.find(params[:id])
  end

  # POST /subscribers
  # POST /subscribers.xml
  def create
    @subscriber = current_user.subscribers.new(params[:subscriber])

    respond_to do |format|
      if @subscriber.save
        format.html { redirect_to(@subscriber, :notice => 'Subscriber was successfully created.') }
        format.xml  { render :xml => @subscriber, :status => :created, :location => @subscriber }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @subscriber.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /subscribers/1
  # PUT /subscribers/1.xml
  def update
    @subscriber = current_user.subscribers.find(params[:id])

    respond_to do |format|
      if @subscriber.update_attributes(params[:subscriber])
        format.html { redirect_to(@subscriber, :notice => 'Subscriber was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @subscriber.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /subscribers/1
  # DELETE /subscribers/1.xml
  def destroy
    @subscriber = current_user.subscribers.find(params[:id])
    @subscriber.destroy

    respond_to do |format|
      format.html { redirect_to(subscribers_url) }
      format.xml  { head :ok }
    end
  end

  # Perform the actual action to upload a file
  def fileupload
   @image = Image.new(params[:image_form])
   @image.save
   render :text => @image.public_filename 
  end
end
