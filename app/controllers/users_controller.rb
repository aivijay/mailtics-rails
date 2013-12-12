class UsersController < ApplicationController

  require 'rubygems'
  require 'active_merchant'
  include ActiveMerchant::Billing::Integrations
  require 'crypto42'
#  require 'money'

  before_filter :authenticate, :only => [:edit, :update]

  def new
    @user = User.new
  end
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to campaigns_path, :notice => 'User successfully added.'
    else
      render :action => 'new'
    end
  end
  def edit
    @user = current_user
  end
  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to campaigns_path, :notice => 'Updated user information successfully.'
    else
      render :action => 'edit'
    end
  end 


  #place order is for a specific job
  def place_order
 
    @job = Job.find(params[:job_id])
    fetch_decrypted(@job)
   
    if @logged_user.credits > 0
      render(:action => "confirm_order")
      return
    else
      #place order will have our paypal buttons
      render(:action => "place_order")
      return
    end
 
    rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Buying credits for fun?"
    redirect_to :action => "profile"
  end
 
private

  def fetch_decrypted(job = nil)
 
    # cert_id is the certificate if we see in paypal when we upload our own certificates
    # cmd _xclick need for buttons
    # item name is what the user will see at the paypal page
    # custom and invoice are passthrough vars which we will get back with the asunchronous
    # notification
    # no_note and no_shipping means the client want see these extra fields on the paypal payment
    # page
    # return is the url the user will be redirected to by paypal when the transaction is completed.
    decrypted = {
      "cert_id" => "G2K2G7HM3SQML",
      "cmd" => "_xclick",
      "business" => "payments@mailtics.com",
      "item_name" => "$ 5 - 100 Credit",
      "item_number" => "1",
      "custom" =>"c1",
      "amount" => "5",
      "currency_code" => "USD",
      "country" => "US",
      "no_note" => "1",
      "no_shipping" => "1",
    }
 
    if job
      decrypted.merge!("invoice" => "mtics_tid", "return" => "http://www.mailtics.com/users/done?job_id=#{job.id}")
    else
      decrypted.merge!("return" => "http://www.mailtics.com")
    end
 
    @encrypted_basic = Crypto42::Button.from_hash(decrypted).get_encrypted_text
 
    @action_url = ENV['RAILS_ENV'] == "production" ? "https://www.paypal.com/uk/cgi-bin/webscr" : "https://www.sandbox.paypal.com/uk/cgi-bin/webscr"
  end

end
