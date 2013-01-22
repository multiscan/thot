class DegIsbnsController < ApplicationController
  def index
    @degisbns=DegIsbn.order("count DESC").paginate(:page=>params[:page], :per_page=>50)
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
  end

  def update
  end
end
