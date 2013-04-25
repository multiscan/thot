class BooksController < ApplicationController
  autocomplete :publisher, :name, :full => true

  # GET /books
  # GET /books.json
  def index
    if @search=params["search"]
      @books = Book.search(@search, :match_mode => :extended)
    else
      @items = Item.order("created_at DESC", :include=>[:book]).paginate(:page=>params[:page], :per_page=>50)
      @books = @items.map{|i| i.book}.uniq
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

  # GET /books/new
  # GET /books/new.json
  def new
    @isbn_step = true
    @book = Book.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @book }
    end
  end

  # GET /books/1/edit
  def edit
    @book = Book.find(params[:id])
  end

  # POST /books
  # POST /books.json
  def create
    if params[:isbn_step]
      @books=Book.new_given_isbn(params[:book][:isbn])
      if @books.count == 1
        @book=@books.first
        if @book.new_record?
          # @labs = Lab.order('nick ASC').all
          # @locations = Location.order('name ASC').all
          # @currencies = ENV['CURRENCIES'].split
          # @item = Item.new
          @isbn_step = false
          render "new"
        else
          flash[:notice] = "A book with the same ISBN number was found on our database. Please review the data."
          render "edit"
        end
      else
        if @books.first.new_record?
          render "new_as_merge"
        else
          flash[:notice] = "More than one book with ISBN #{params[:book][:isbn]} was found. Please select the one your want and then add items to it."
          render "index"
        end
      end
    else
      @book = Book.new(params[:book])

      respond_to do |format|
        if @book.save
          format.html { redirect_to new_book_item_path(@book), notice: 'Book was successfully created.' }
          format.json { render json: @book, status: :created, location: @book }
        else
          format.html { render action: "new" }
          format.json { render json: @book.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /books/1
  # PUT /books/1.json
  def update
    @book = Book.find(params[:id])

    respond_to do |format|
      if @book.update_attributes(params[:book])
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book = Book.find(params[:id])
    @book.destroy

    respond_to do |format|
      format.html { redirect_to books_url }
      format.json { head :no_content }
    end
  end
end
