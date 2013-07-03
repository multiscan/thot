class Adm::DegIsbnsController < AdmController
  def index
    @degisbns=DegIsbn.order("count DESC").paginate(:page=>params[:page], :per_page=>200)
  end

  # GET /isbn_dedup/1
  def show
    @degisbn=DegIsbn.find(params["id"])
    @books=@degisbn.books
  end

  # GET /isbn_dedup/1/edit
  def edit
    @degisbn=DegIsbn.find(params["id"])
    @books=@degisbn.books
    @book=Book.new
  end

  # TODO: prevent multiple users from merging the same isbn
  def update
    @degisbn=DegIsbn.find(params["id"])
    isbn=@degisbn.isbn
    @book=Book.new(book_params.merge({:isbn=>isbn}))
    if @book.save
      @degisbn.count = @degisbn.count + 1
      @degisbn.books.find(params["merge_book_ids"]).each do |b|
        b.items.each do |i|
          @book.items << i
        end
        b.destroy
        @degisbn.count = @degisbn.count - 1
      end
      @degisbn.save
      if @degisbn.count==1
        @degisbn.destroy
        @degisbns=DegIsbn.order("count DESC").paginate(:page=>params[:page], :per_page=>200)
        flash[:notice] = "Isbn #{isbn} is no longer degenerate. Thank you!"
        render :action => "index"
      else
        @books = @degisbn.books
        flash[:notice] = "Still some degenerate books with ISBN #{isbn}"
        render :action => "edit"
      end
    else
      render :action => "edit"
    end
  end

 private

  def book_params
    params.require(:book).permit :abstract, :author, :call1, :call2, :call3, :call4, :categories, :collation, :collection, :currency, :edition, :editor, :idx, :isbn, :language, :notes, :price, :pubyear, :title, :toc, :publisher_name, :subtitle, :volume
  end

end
