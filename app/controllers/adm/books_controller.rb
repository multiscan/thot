class Adm::BooksController < AdmController
  # TODO: re-enable autocomplete when a rails4 compatible version is out
  # autocomplete :publisher, :name, :full => true


  # GET /adm/books
  def index
    @books = (
      case params[:with]
      when 'badISBN'
        @subtitle = "With bad ISBN numbers"
        Book.where('isbn IS NOT NULL AND length(isbn) != 13 AND length(isbn) != 10')
      else
        Book.order('updated_at DESC')
      end
    ).paginate(:page=>params[:page], :per_page=>50)
    respond_to do |format|
      format.html { render 'books/index' }
    end
  end

  # GET /adm/books/new
  def new
    @isbn_step = true
    @book = Book.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /adm/books/1/edit
  def edit
    @book = Book.find(params[:id])
  end

  # POST /adm/books
  def create
    if params[:isbn_step]
      @books=Book.new_given_isbn(book_params[:isbn])
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
          @book = Book.new(book_params)
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
      @book = Book.new(book_params)

      respond_to do |format|
        if @book.save
          format.html { redirect_to new_adm_book_item_path(@book), notice: 'Book was successfully created.' }
        else
          format.html { render action: "new" }
        end
      end
    end
  end

  # PUT /adm/books/1
  def update
    @book = Book.find(params[:id])

    respond_to do |format|
      if @book.update_attributes(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /adm/books/1
  def destroy
    @book = Book.find(params[:id])
    @book.destroy

    respond_to do |format|
      format.html { redirect_to books_url }
    end
  end

 private

  def book_params
    params.require(:book).permit :abstract, :author, :call1, :call2, :call3, :call4, :categories, :collation, :collection, :currency, :edition, :editor, :idx, :isbn, :language, :notes, :price, :pubyear, :title, :toc, :publisher_name, :subtitle, :volume
  end

end
