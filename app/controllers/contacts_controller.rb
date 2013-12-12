class ContactsController < ApplicationController
  respond_to :html,:xml,:json

  def post_data
    message=""
    contact_params = { :name => params[:name], :description => params[:description],:updated_at => params[:updated_at],:status => params[:status],:user_id => params[:user_id] }
    case params[:oper]
    when 'add'
      if params["id"] == "_empty"
        contact = Contact.create(contact_params)
        message << ('add ok') if contact.errors.empty?
      end

    when 'edit'
      #email = Email.find(params[:id])
      contact = Contact.find(params[:id])
      message << ('update ok') if contact.update_attributes(contact_params)
    when 'del'
      Email.destroy_all(:id => params[:id].split(","))
      message <<  ('del ok')
    when 'sort'
     # emails = Email.all
     contacts = current_user.contacts
      contacts.each do |contact|
        contact.position = params['ids'].index(contact.id.to_s) + 1 if params['ids'].index(contact.id.to_s)
        contact.save
      end
      message << "sort ak"
    else
      message <<  ('unknown action')
    end

    unless (contact && contact.errors).blank?
      contact.errors.entries.each do |error|
        message << "<strong>#{Contact.human_attribute_name(error[0])}</strong> : #{error[1]}<br/>"
      end
      render :json =>[false,message]
    else
      render :json => [true,message]
    end
  end


  def subscribers
    cl = Contact.find(params[:id])
    @cl_name = cl.name
    #@subscribers = cl.subscribers.order("email")
    @subscribers = cl.subscribers.order("email").paginate(:per_page => 20, :page => params[:page])
    @total = cl.subscribers.count
  end
  # GET /contacts
  # GET /contacts.xml
  def index

    index_columns ||= [:name,:description,:updated_at,:status_string,:created_user]
    current_page = params[:page] ? params[:page].to_i : 1
    rows_per_page = params[:rows] ? params[:rows].to_i : 10

    conditions={:page => current_page, :per_page => rows_per_page}
    conditions[:order] = params["sidx"] + " " + params["sord"] unless (params[:sidx].blank? || params[:sord].blank?)
    
    if params[:_search] == "true"
      conditions[:conditions]=filter_by_conditions(index_columns)
    end
    
    @contacts = current_user.contacts.where(conditions[:conditions]).order(conditions[:order]).paginate(conditions)
    total_entries=@contacts.total_entries
    @total = total_entries

    count = @contacts.count - 1
    for i in 0..count
      name = @contacts[i].name
      @contacts[i].name = "<b><a>"+ name +"</a></b>"
      #@contacts[i].name = '
      #<h3> 
      #  <a href="/subscribers/2304">email99@mailtics.com</a> 
      #    <span class="actions"> 
      #      <a href="/subscribers/2304/edit">Edit</a> 
      #      <a href="/subscribers/2304" data-confirm="Are you sure?" data-method="delete" rel="nofollow">Delete</a> 
      #    </span> 
      #</h3>'
    
      id = @contacts[i].id.to_s
      @contacts[i].name = '<h3 class="dlink">  <a href="/contacts/' + id + '" style="color: #00008d;">' + name + '</a><span class="actions">  <a href="/contacts/' + id + '/subscribers">Subscribers</a>  <a href="/contacts/' + id + '/edit">Edit</a>  <a href="/contacts/' + id + '" data-confirm="Are you sure?" data-method="delete" rel="nofollow">Delete</a></span></h3>'

#      @contacts[i].status = status 
    end

    respond_with(@contacts) do |format|
      format.json { render :json => @contacts.to_jqgrid_json(index_columns, current_page, rows_per_page, total_entries)}  
    end



    #@contacts = Contact.all
    #####@contacts = current_user.contacts.order("contacts.updated_at DESC").paginate(:per_page => 20, :page => params[:page])

#    @total = current_user.contacts.count
#
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @contacts }
#      format.json  { render :json => @contaCTs.to_jqgrid_json(index_columns, current_page, rows_per_page, total_entries) }
#    end
  end

  # GET /contacts/1
  # GET /contacts/1.xml
  def show
    @contact = Contact.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @contact }
    end
  end

  # GET /contacts/new
  # GET /contacts/new.xml
  def new
    @contact = Contact.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @contact }
    end
  end

  # GET /contacts/1/edit
  def edit
    @contact = Contact.find(params[:id])
  end

  # POST /contacts
  # POST /contacts.xml
  def create
    @contact = current_user.contacts.new(params[:contact])

    respond_to do |format|
      if @contact.save
        format.html { redirect_to(@contact, :notice => 'Contact was successfully created.') }
        format.xml  { render :xml => @contact, :status => :created, :location => @contact }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /contacts/1
  # PUT /contacts/1.xml
  def update
    @contact = current_user.contacts.find(params[:id])

    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        format.html { redirect_to(@contact, :notice => 'Contact was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.xml
  def destroy
    @contact = current_user.contacts.find(params[:id])
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to(contacts_url) }
      format.xml  { head :ok }
    end
  end
end
