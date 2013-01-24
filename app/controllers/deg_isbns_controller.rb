class DegIsbnsController < ApplicationController
  def index
    @degisbns=DegIsbn.order("count DESC").paginate(:page=>params[:page], :per_page=>200)
  end

  # GET /isbn_dedup/1
  def show
    @isbn=DegIsbn.find(params["id"])
    @books=@isbn.books
  end

  # GET /isbn_dedup/1/edit
  def edit
    @isbn=DegIsbn.find(params["id"])
    @books=@isbn.books
    @book=Book.new
  end

  # TODO: prevent multiple users from merging the same isbn
  def update
    @degisbn=DegIsbn.find(params["id"])
    isbn=@degisbn.isbn
    @book=Book.new(params["book"].merge({:isbn=>isbn}))
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
        render :action => "index", :notice => "Isbn #{isbn} is no longer degenerate. Thank you!"
      else
        @books = @degisbn.books
        render :action => "edit", :notice => "Still some degenerate books with ISBN #{isbn}"
      end
    else
      render :action => "edit"
    end
  end
end
