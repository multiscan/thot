class IsbnDedupController < ApplicationController

  def index
    @degisbns=DegIsbn.order("count ASC")
  end

  # GET /isbn_dedup/1
  def edit
  end

  def update
  end
end
