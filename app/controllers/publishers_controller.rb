class PublishersController < ApplicationController

  # # GET /publishers
  # # GET /publishers.json
  # def index
  #   @publishers = Publisher.all

  #   respond_to do |format|
  #     format.html # index.html.erb
  #     format.json { render json: @publishers }
  #   end
  # end

  # GET /publishers/1
  # GET /publishers/1.json
  def show
    @publisher = Publisher.find(params[:id])
    @books = @publisher.books.paginate(:page=>params[:page], :per_page=>50)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @publisher }
    end
  end
end
