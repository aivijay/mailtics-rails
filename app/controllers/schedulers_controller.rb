class SchedulersController < ApplicationController


  respond_to :html,:xml,:json

  def post_data
    message=""
    scheduler_params = { :campaign_name => params[:campaign_name], :schedule_time => params[:schedule_time], :priority => params[:priority] ,:status => params[:status],:updated_at => params[:updated_at],:user_id => params[:user_id] }
    case params[:oper]
    when 'add'
      if params["id"] == "_empty"
        scheduler = Scheduler.create(scheduler_params)
        message << ('add ok') if scheduler.errors.empty?
      end

    when 'edit'
      scheduler = Scheduler.find(params[:id])
      message << ('update ok') if scheduler.update_attributes(scheduler_params)
    when 'del'
      #Scheduler.destroy_all(:id => params[:id].split(","))
      message <<  ('del ok')
    when 'sort'
     schedulers = current_user.schedulers
      schedulers.each do |scheduler|
        scheduler.position = params['ids'].index(scheduler.id.to_s) + 1 if params['ids'].index(scheduler.id.to_s)
        scheduler.save
      end
      message << "sort ak"
    else
      message <<  ('unknown action')
    end

    unless (scheduler && scheduler.errors).blank?
      scheduler.errors.entries.each do |error|
        message << "<strong>#{Scheduler.human_attribute_name(error[0])}</strong> : #{error[1]}<br/>"
      end
      render :json =>[false,message]
    else
      render :json => [true,message]
    end
  end


  # GET /schedulers
  # GET /schedulers.xml
  def index


    index_columns ||= [:campaign_name,:schedule_time,:priority,:status_string,:updated_at,:created_user]
    current_page = params[:page] ? params[:page].to_i : 1
    rows_per_page = params[:rows] ? params[:rows].to_i : 10

    conditions={:page => current_page, :per_page => rows_per_page}

    params["sidx"] = "status" if (params["sidx"] == "status_string")
    params["sidx"] = "user_id" if (params["sidx"] == "created_user")

    conditions[:order] = params["sidx"] + " " + params["sord"] unless (params[:sidx].blank? || params[:sord].blank?)
    
    if params[:_search] == "true"
      conditions[:conditions]=filter_by_conditions(index_columns)
    end
    
    conditions[:order] = conditions[:order] ? conditions[:order] : " updated_at DESC "    
    @schedulers = current_user.schedulers.where(conditions[:conditions]).order(conditions[:order]).paginate(conditions)
    total_entries=@schedulers.total_entries
    @total = total_entries

    count = @schedulers.count - 1
    for i in 0..count
#      name = @schedulers[i].campaign_name
    
#      id = @schedulers[i].id.to_s
#      @schedulers[i].campaign_name = '<h3 class="dlink"><a href="/schedulers/' + id + '" style="font-size: 12px; color: #00008d;">' + name + '</a><span class="actions">  <a href="/schedulers/' + id + '/edit">Edit</a>  <a href="/schedulers/' + id + '" data-confirm="Are you sure?" data-method="delete" rel="nofollow">Delete</a></span></h3>'

      status_string = @schedulers[i].status_string
      
    end

    respond_with(@schedulers) do |format|
      format.json { render :json => @schedulers.to_jqgrid_json(index_columns, current_page, rows_per_page, total_entries)}  
    end




#    @schedulers = current_user.schedulers.order("schedulers.updated_at DESC").paginate(:per_page => 20, :page => params[:page])
#    @total = @schedulers.count
#
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @schedulers }
#      format.json  { render :json => @schedulers }
#    end
  end

  # GET /schedulers/1
  # GET /schedulers/1.xml
  def show
    @scheduler = Scheduler.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @scheduler }
    end
  end

  # GET /schedulers/new
  # GET /schedulers/new.xml
  def new
    @scheduler = Scheduler.new

    @campaigns = current_user.campaigns.active
    @contacts_list = current_user.contacts.active
    @contents_list = current_user.contents.active

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @scheduler }
    end
  end

  # GET /schedulers/1/edit
  def edit
    @scheduler = Scheduler.find(params[:id])

    @campaigns = current_user.campaigns.active
    @contacts_list = current_user.contacts.active
    @contents_list = current_user.contents.active
  end

  # POST /schedulers
  # POST /schedulers.xml
  def create
    @scheduler = current_user.schedulers.new(params[:scheduler])

    respond_to do |format|
      if @scheduler.save
        format.html { redirect_to(@scheduler, :notice => 'Scheduler was successfully created.') }
        format.xml  { render :xml => @scheduler, :status => :created, :location => @scheduler }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @scheduler.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /schedulers/1
  # PUT /schedulers/1.xml
  def update
    @scheduler = current_user.schedulers.find(params[:id])

    respond_to do |format|
      if @scheduler.update_attributes(params[:scheduler])
        format.html { redirect_to(@scheduler, :notice => 'Scheduler was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @scheduler.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /schedulers/1
  # DELETE /schedulers/1.xml
  def destroy
    @scheduler = current_user.schedulers.find(params[:id])
    @scheduler.destroy

    respond_to do |format|
      format.html { redirect_to(schedulers_url) }
      format.xml  { head :ok }
    end
  end
end
