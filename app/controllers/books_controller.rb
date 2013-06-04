class BooksController < ApplicationController
  autocomplete :publisher, :name, :full => true

  # GET /books
  # GET /books.json
  def index
    if @search=params["search"]
      @books = Book.search(@search, :match_mode => :extended).paginate(:page=>params[:page], :per_page=>50)
      @paginate = @books
    else
      @items = Item.order("created_at DESC", :include=>[:book]).paginate(:page=>params[:page], :per_page=>50)
      @books = @items.map{|i| i.book}.uniq
      @paginate = @items
      # @books = Book.order("created_at DESC", :include=>[:publisher, :items, :loans]).paginate(:page=>params[:page], :per_page=>50)
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @books }
    end
  end

  # GET /books/1
  # GET /books/1.json
  def show
    @book = Book.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @book }
    end
  end

end
