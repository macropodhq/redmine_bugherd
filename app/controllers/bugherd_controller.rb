class BugherdController < ApplicationController
  unloadable
  before_filter :require_admin

  def update
    
    render :text => 'Yes'
  end
end
