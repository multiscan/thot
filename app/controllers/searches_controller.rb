class SearchesController < ApplicationController
  # TODO: re-enable autocomplete when a rails4 compatible version is out
  # autocomplete :publisher, :name, :full => true

  # GET /searches
  # GET /searches.json
  def index
    @searches = Search.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @searches }
    end
  end

  # GET /searches/1
  # GET /searches/1.json
  def show
    @search = Search.find(params[:id])
    perpage = request.format == 'pdf' ? 999 : 48
    @search.search(page: params[:page], :per_page => perpage)
    if @search.total_entries == 1
      @entry = @search.items_oriented? ? @search.items.first : @search.books.first
    end
    respond_to do |format|
      format.pdf  { @items = @search.items ; render 'items/index' }
      format.html do
        redirect_to @entry unless @entry.nil?
        # show.html.erb
      end
    end
  end

  # GET /searches/new
  # GET /searches/new.json
  def new
    gon.root = true
    @search = Search.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @search }
    end
  end

  # GET /searches/1/edit
  def edit
    @search = Search.find(params[:id])
  end

  # POST /searches
  # POST /searches.json
  def create
    @search = Search.new(search_params)
    if @search.simple_query?
      redirect_to books_path(:search=>@search.query)
    else
      respond_to do |format|
        if @search.save
          format.html { redirect_to @search, notice: 'Search was successfully created.' }
          format.json { render json: @search, status: :created, location: @search }
        else
          format.html { render action: "new" }
          format.json { render json: @search.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /searches/1
  # PUT /searches/1.json
  def update
    @search = Search.find(params[:id])

    respond_to do |format|
      if @search.update_attributes(search_params)
        format.html { redirect_to @search, notice: 'Search was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @search.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /searches/1
  # DELETE /searches/1.json
  def destroy
    @search = Search.find(params[:id])
    @search.destroy

    respond_to do |format|
      format.html { redirect_to searches_url }
      format.json { head :no_content }
    end
  end

 private

  def search_params
    params.require(:search).permit(:query, :isbn, :publisher_name, :year_range, :inv_range, :lab_id, :location_id, :status, :inv_date_fr, :inv_date_to)
  end

end
