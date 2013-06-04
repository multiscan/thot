class Adm::PublishersController < AdmController
  before_filter :administrator_only!

  # GET /adm/publishers
  # GET /adm/publishers.json
  def index
    @publishers = Publisher.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @publishers }
    end
  end

  # # GET /adm/publishers/1
  # # GET /adm/publishers/1.json
  # def show
  #   @publisher = Publisher.find(params[:id])
  #   @books = @publisher.books.limit(100)
  #   respond_to do |format|
  #     format.html # show.html.erb
  #     format.json { render json: @publisher }
  #   end
  # end

  # GET /adm/publishers/new
  # GET /adm/publishers/new.json
  def new
    @publisher = Publisher.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @publisher }
    end
  end

  # GET /adm/publishers/1/edit
  def edit
    @publisher = Publisher.find(params[:id])
  end

  # POST /adm/publishers
  # POST /adm/publishers.json
  def create
    @publisher = Publisher.new(params[:publisher])

    respond_to do |format|
      if @publisher.save
        format.html { redirect_to @publisher, notice: 'Publisher was successfully created.' }
        format.json { render json: @publisher, status: :created, location: @publisher }
      else
        format.html { render action: "new" }
        format.json { render json: @publisher.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /adm/publishers/1
  # PUT /adm/publishers/1.json
  def update
    @publisher = Publisher.find(params[:id])

    respond_to do |format|
      if @publisher.update_attributes(params[:publisher])
        format.html { redirect_to @publisher, notice: 'Publisher was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @publisher.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /adm/publishers/1
  # DELETE /adm/publishers/1.json
  def destroy
    @publisher = Publisher.find(params[:id])
    @publisher.destroy

    respond_to do |format|
      format.html { redirect_to publishers_url }
      format.json { head :no_content }
    end
  end
end
