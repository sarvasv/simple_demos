class ProductsController < ApplicationController
  #   * we have to use them in helper also
  helper_method :sort_column, :sort_direction
   
  # GET /products
  # GET /products.xml
  # GET /search
  def index
    #   * when we have a search form submitting to this action, use its params
    #   * otherwise accommodate the standard header clicks
    #   * to re-use the existing code and keep DRY, we kept the form element names same. keeping the names same is not mandatory
    sql_command = [ 
      "SELECT * FROM products", # we need this in both cases
      ( params[:q] ? "WHERE name LIKE '%#{params[:q]}%'" : ''), # this is optional string evaluated only when attribute given
      "ORDER BY #{sort_column} #{sort_direction}" # required in both cases
      ].join(' ')
    #   * fire this custom SQL which includes the sort algorithm, and search conditions (of form was submitted instead of clicking header)
    @products = Product.find_by_sql( sql_command)
    # 
    #  Mon Aug 29 12:15:52 IST 2011, ramonrails
    #   * direct SQL query without a model
    #   * in this case, @product.name is not going to work. the code should fetch data from result array using field index
    #
    #   ActiveRecord::Base.connection.select_rows( "SELECT * FROM products").first
    #   => [1, "one", "10", "2011-08-19 19:45:42.499558", "2011-08-19 19:45:42.499558"]
    #
    # @products = ActiveRecord::Base.connection.select_rows( "SELECT * FROM products ORDER BY #{sort_column} #{sort_direction}").first

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @products }
    end
  end
  
  # GET /products/1
  # GET /products/1.xml
  def show
    @product = Product.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product }
    end
  end

  # GET /products/new
  # GET /products/new.xml
  def new
    @product = Product.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @product }
    end
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
  end

  # POST /products
  # POST /products.xml
  def create
    apply_other_price_if_required
    @product = Product.new(params[:product])
    
    respond_to do |format|
      if @product.save
        format.html { redirect_to(@product, :notice => 'Product was successfully created.') }
        format.xml  { render :xml => @product, :status => :created, :location => @product }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.xml
  def update
    @product = Product.find(params[:id])
    apply_other_price_if_required

    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to(@product, :notice => 'Product was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.xml
  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to(products_url) }
      format.xml  { head :ok }
    end
  end

  private # invisible actions
  
  def apply_other_price_if_required
    #   * we need to apply other_price
    if params[:dropdown_1] == 'Other'
      params[:product][:price] = params[:other_price]
    end
  end
  
  def sort_column
    (Product.column_names & [params[ :sort]]).blank? ? "name" : params[ :sort]
  end
  
  def sort_direction
    (["asc", "desc"] & [params[ :direction]]).blank? ? "asc" : params[ :direction]
  end
end
