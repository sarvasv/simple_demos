class WelcomeController < ApplicationController
  # 
  #  Fri Aug 19 16:45:33 IST 2011, ramonrails
  #   * just quick way around to define a constant here
  #   * we need this constant in this controller anyways
  DEMOS = (1..4)
  DEMO_NAMES = {
    3 => "Dynamically add fields in form",
    4 => "Sortable columns"
  }
  
  def index
    # 
    #  Fri Aug 19 23:47:25 IST 2011, ramonrails
    #   * fetch the range in the view > dynamically create list of demos
    @demos = DEMOS
    @demo_names = DEMO_NAMES
  end

  # 
  #  Fri Aug 19 16:37:12 IST 2011, ramonrails
  #   * dynaically define demo_1, demo_n actions
  #   * we opened up good old /controller/action.format route to handle this
  DEMOS.each { |num| define_method "demo_#{num}".to_sym do; end }
end
