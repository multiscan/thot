class Adm::DegIsbnsController < AdmController
  def index
    @degisbns=DegIsbn.paginate(:page=>params[:page], :per_page=>200)
  end

  # GET /isbn_dedup/1
  def show
    @degisbn=DegIsbn.find(params["id"])
    set_prev_next
    set_books
  end

  # GET /isbn_dedup/1/edit
  def edit
    @degisbn=DegIsbn.find(params["id"])
    set_prev_next_editable
    set_books
  end

  # GET /isbn_dedup/1/skip
  def skip
    skippand=DegIsbn.find(params["id"])
    skippand.skip=true
    skippand.save
    @degisbn=DegIsbn.editable.where("id > #{skippand.id}").first
    set_prev_next_editable
    set_books
    flash[:notice] = "Degenerate ISBN #{skippand.isbn} marked as unmergeable"
    render action: "edit"
  end

  # TODO: prevent multiple users from merging the same isbn
  def update
    @degisbn=DegIsbn.find(params["id"])
    isbn=@degisbn.isbn
    @book=Book.new(book_params)
    @book.isbn=isbn
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
        myid=@degisbn.id
        @degisbn.destroy
        @degisbn=DegIsbn.editable.where("id > #{myid}").first
        set_prev_next_editable
        set_books
        flash[:notice] = "Isbn #{isbn} is no longer degenerate. Thank you!"
        render :action => :edit
      else
        set_prev_next_editable
        set_books
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

  def set_prev_next_editable
    @prev = DegIsbn.editable.where("id < #{@degisbn.id}").last
    @next = DegIsbn.editable.where("id > #{@degisbn.id}").first
  end

  def set_prev_next
    @prev = DegIsbn.where("id < #{@degisbn.id}").last
    @next = DegIsbn.where("id > #{@degisbn.id}").first
  end

  def set_books
    @books=@degisbn.books
    @book=Book.new
  end
end
