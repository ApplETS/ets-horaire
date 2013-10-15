require_relative '../controller'
require_relative '../views/landing_view'

class LandingController < Controller
  def index
    render 'index'
    go_to :index, :input
  end
end