class WelcomeController < ApplicationController
  # 
  #  Fri Aug 19 16:45:33 IST 2011, ramonrails
  #   * just quick way around to define a constant here
  #   * we need this constant in this controller anyways
  DEMOS = (1..3)
  
  def index
    @demos = DEMOS
  end

  # 
  #  Fri Aug 19 16:37:12 IST 2011, ramonrails
  #   * dynaically define demo_1, demo_n actions
  #   * we opened up good old /controller/action.format route to handle this
  DEMOS.each { |num| define_method "demo_#{num}".to_sym do; end }
end
