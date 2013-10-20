# -*- encoding : utf-8 -*-

class LandingController < Controller
  def index
    render 'index'
    redirect_to :index, :input
  end
end
