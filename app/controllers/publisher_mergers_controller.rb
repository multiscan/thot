class PublisherMergersController < ApplicationController
  # GET /publisher_mergers/new
  def new
    @publishers = Publisher.order("name ASC").all
    @publisher = Publisher.new
  end

  # # GET /publisher_mergers/1/edit
  # def edit
  #   @publisher_merger = PublisherMerger.find(params[:id])
  # end

  # POST /publisher_mergers
  def create
    @publishers=Publisher.find(params["mergenda_ids"])
    @publisher=Publisher.new(params["publisher"])
    if params["commit"] == "Merge"
      render action: "edit"
    else
      np=@publishers.count
      nb=0
      if @publisher.save
        @publishers.each do |p|
          p.books.each do |b|
            nb=nb+1
            b.publisher = @publisher
            b.save
          end
          p.destroy
        end
        redirect_to new_publisher_merger_path, :notice => "Merged #{np} publishers (#{nb} books). Thank you!"
      else
        redirect_to new_publisher_merger_path, :notice => 'Something went wrong. Failed to merge publishers.'
      end
    end
  end

end
