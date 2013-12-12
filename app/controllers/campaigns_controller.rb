class CampaignsController < ApplicationController
  before_filter :authenticate


  respond_to :html,:xml,:json

  def post_data
    message=""
    campaign_params = { :name => params[:name], :description => params[:description],:status => params[:status],:updated_at => params[:updated_at],:user_id => params[:user_id] }
    case params[:oper]
    when 'add'
      if params["id"] == "_empty"
        campaign = Campaign.create(campaign_params)
        message << ('add ok') if campaign.errors.empty?
      end

    when 'edit'
      campaign = Campaign.find(params[:id])
      message << ('update ok') if campaign.update_attributes(campaign_params)
    when 'del'
      Email.destroy_all(:id => params[:id].split(","))
      message <<  ('del ok')
    when 'sort'
     campaigns = current_user.campaigns
      campaigns.each do |campaign|
        campaign.position = params['ids'].index(campaign.id.to_s) + 1 if params['ids'].index(campaign.id.to_s)
        campaign.save
      end
      message << "sort ak"
    else
      message <<  ('unknown action')
    end

    unless (campaign && campaign.errors).blank?
      campaign.errors.entries.each do |error|
        message << "<strong>#{Campaign.human_attribute_name(error[0])}</strong> : #{error[1]}<br/>"
      end
      render :json =>[false,message]
    else
      render :json => [true,message]
    end
  end




  # GET /campaigns
  # GET /campaigns.xml
  def index

    index_columns ||= [:name,:description,:status_string,:updated_at,:created_user]
    current_page = params[:page] ? params[:page].to_i : 1
    rows_per_page = params[:rows] ? params[:rows].to_i : 10

    conditions={:page => current_page, :per_page => rows_per_page}

    params["sidx"] = "status" if (params["sidx"] == "status_string")
    params["sidx"] = "user_id" if (params["sidx"] == "created_user")
    conditions[:order] = params["sidx"] + " " + params["sord"] unless (params[:sidx].blank? || params[:sord].blank?)
    
    if params[:_search] == "true"
      conditions[:conditions]=filter_by_conditions(index_columns)
    end
    
    
    @campaigns = current_user.campaigns.where(conditions[:conditions]).order(conditions[:order]).paginate(conditions)
    total_entries=@campaigns.total_entries
    @total = total_entries

    count = @campaigns.count - 1
    for i in 0..count
      name = @campaigns[i].name
      #@subscribers[i].email = "<b><a>"+ email +"</a></b>"
    
      id = @campaigns[i].id.to_s
      @campaigns[i].name = '<h3 class="dlink"><a href="/campaigns/' + id + '" style="font-size: 12px; color: #00008d;">' + name + '</a><span class="actions">  <a href="/campaigns/' + id + '/edit">Edit</a>  <a href="/campaigns/' + id + '" data-confirm="Are you sure?" data-method="delete" rel="nofollow">Delete</a></span></h3>'

    end

    respond_with(@campaigns) do |format|
      format.json { render :json => @campaigns.to_jqgrid_json(index_columns, current_page, rows_per_page, total_entries)}  
    end






#    @campaigns = current_user.campaigns.order("campaigns.updated_at").paginate(:per_page => 20, :page => params[:page])
#    @total = current_user.campaigns.count

#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @campaigns }
#      format.json { render :json => @campaigns }
#    end
  end

  # GET /campaigns/1
  # GET /campaigns/1.xml
  def show
    @campaign = Campaign.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @campaign }
      format.json { render :json => @campaign }
    end
  end

  # GET /campaigns/new
  # GET /campaigns/new.xml
  def new
    @campaign = Campaign.new
    @contacts_list = current_user.contacts.active
    @contents_list = current_user.contents.active

    logger.warn "debug: ====================>>>>> contacts_list = [" + @contacts_list.to_s + "]"

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @campaign }
    end
  end

  # GET /campaigns/1/edit
  def edit
    @campaign = current_user.campaigns.find(params[:id])
    @contacts_list = current_user.contacts.active
    @contents_list = current_user.contents.active
  end

  # POST /campaigns
  # POST /campaigns.xml
  def create
    @campaign = current_user.campaigns.new(params[:campaign])

    respond_to do |format|
      if @campaign.save
        format.html { redirect_to(@campaign, :notice => 'Campaign was successfully created.') }
        format.xml  { render :xml => @campaign, :status => :created, :location => @campaign }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @campaign.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /campaigns/1
  # PUT /campaigns/1.xml
  def update
    @campaign = current_user.campaigns.find(params[:id])

    respond_to do |format|
      if @campaign.update_attributes(params[:campaign])
        format.html { redirect_to(@campaign, :notice => 'Campaign was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @campaign.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /campaigns/1
  # DELETE /campaigns/1.xml
  def destroy
    @campaign = current_user.campaigns.find(params[:id])
    @campaign.destroy

    respond_to do |format|
      format.html { redirect_to(campaigns_url) }
      format.xml  { head :ok }
    end
  end
end
