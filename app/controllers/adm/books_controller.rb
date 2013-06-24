class Adm::BooksController < ApplicationController
  autocomplete :publisher, :name, :full => true

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
          @book = Book.new(params[:book])
          render "new_as_merge"
        else
          @isbn = params[:book][:isbn]
          @deg_isbn = DegIsbn.where(:isbn => @isbn).first
          flash[:notice] = "Degenerate ISBN"
          # render "books/index" #, :collection => @books
          # # render "index"
        end
      end
    else
      @book = Book.new(params[:book])

      respond_to do |format|
        if @book.save
          format.html { redirect_to new_adm_book_item_path(@book), notice: 'Book was successfully created.' }
        else
          format.html { render action: "new" }
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
