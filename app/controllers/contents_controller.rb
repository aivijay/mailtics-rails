class ContentsController < ApplicationController
  respond_to :html,:xml,:json

  def post_data
    message=""
    content_params = { :name => params[:name], :subject => params[:subject],:status => params[:status],:updated_at => params[:updated_at],:user_id => params[:user_id] }
    case params[:oper]
    when 'add'
      if params["id"] == "_empty"
        content = Content.create(content_params)
        message << ('add ok') if content.errors.empty?
      end

    when 'edit'
      content = Content.find(params[:id])
      message << ('update ok') if content.update_attributes(content_params)
    when 'del'
      Email.destroy_all(:id => params[:id].split(","))
      message <<  ('del ok')
    when 'sort'
     contents = current_user.contents
      contents.each do |content|
        content.position = params['ids'].index(content.id.to_s) + 1 if params['ids'].index(content.id.to_s)
        content.save
      end
      message << "sort ak"
    else
      message <<  ('unknown action')
    end

    unless (content && content.errors).blank?
      content.errors.entries.each do |error|
        message << "<strong>#{Content.human_attribute_name(error[0])}</strong> : #{error[1]}<br/>"
      end
      render :json =>[false,message]
    else
      render :json => [true,message]
    end
  end



  # GET /contents
  # GET /contents.xml
  def index

    #@content_lists_count = current_user.contents.count
    #@total = current_user.contents.count

    #@contents = current_user.contents.order("contents.updated_at").paginate(:per_page => 20, :page => params[:page])
    #@total = current_user.contents.count

    index_columns ||= [:name,:subject,:status_string,:updated_at,:created_user]
    current_page = params[:page] ? params[:page].to_i : 1
    rows_per_page = params[:rows] ? params[:rows].to_i : 10

    conditions={:page => current_page, :per_page => rows_per_page}
    conditions[:order] = params["sidx"] + " " + params["sord"] unless (params[:sidx].blank? || params[:sord].blank?)
    
    if params[:_search] == "true"
      conditions[:conditions]=filter_by_conditions(index_columns)
    end
    
    @contents = current_user.contents.where(conditions[:conditions]).order(conditions[:order]).paginate(conditions)
    total_entries=@contents.total_entries
    @total = total_entries

    count = @contents.count - 1
    for i in 0..count
      name = @contents[i].name
      #@subscribers[i].email = "<b><a>"+ email +"</a></b>"
    
      id = @contents[i].id.to_s
      @contents[i].name = '<h3 class="dlink"><a href="/contents/' + id + '" style="color: #00008d;">' + name + '</a><span class="actions">  <a href="/contents/' + id + '/edit">Edit</a>  <a href="/contents/' + id + '" data-confirm="Are you sure?" data-method="delete" rel="nofollow">Delete</a></span></h3>'

    end

    respond_with(@contents) do |format|
      format.json { render :json => @contents.to_jqgrid_json(index_columns, current_page, rows_per_page, total_entries)}  
    end



    #@contacts = Contact.all


#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @contents }
#      format.json  { render :json => @contents }
#    end
  end

  # GET /contents/1
  # GET /contents/1.xml
  def show
    @content = Content.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @content }
    end
  end

  # GET /contents/new
  # GET /contents/new.xml
  def new
    @content = Content.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @content }
    end
  end

  # GET /contents/1/edit
  def edit
    @content = current_user.contents.find(params[:id])
  end

  # POST /contents
  # POST /contents.xml
  def create
    @content = current_user.contents.new(params[:content])

    respond_to do |format|
      if @content.save
        format.html { redirect_to(@content, :notice => 'Content was successfully created.') }
        format.xml  { render :xml => @content, :status => :created, :location => @content }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @content.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /contents/1
  # PUT /contents/1.xml
  def update
    @content = current_user.contents.find(params[:id])

    respond_to do |format|
      if @content.update_attributes(params[:content])
        format.html { redirect_to(@content, :notice => 'Content was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @content.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /contents/1
  # DELETE /contents/1.xml
  def destroy
    @content = current_user.contents.find(params[:id])
    @content.destroy

    respond_to do |format|
      format.html { redirect_to(contents_url) }
      format.xml  { head :ok }
    end
  end
end
