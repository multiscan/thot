class Adm::LabelLayoutsController < AdmController

   respond_to :html

  # GET /admin/label_layouts
  def index
    @label_layouts = LabelLayout.all
    respond_with @label_layouts
  end

  # GET /admin/label_layouts/1
  def show
    @label_layout = LabelLayout.find(params[:id])
    respond_with @label_layout
  end

  # GET /admin/label_layouts/new
  def new
    authorize! :create, LabelLayout
    @label_layout = LabelLayout.new
    respond_with @label_layout
  end

  # GET /admin/label_layouts/1/edit
  def edit
    @label_layout = LabelLayout.find(params[:id])
    authorize! :update, @label_layout
    respond_with @label_layout
  end

  # POST /admin/label_layouts
  def create
    @label_layout = LabelLayout.new(label_layout_params)
    authorize! :create, @label_layout
    respond_to do |format|
      if @label_layout.save
        format.html { redirect_to [:adm, @label_layout], notice: 'LabelLayout was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /admin/label_layouts/1
  # PUT /admin/label_layouts/1.json
  def update
    @label_layout = LabelLayout.find(params[:id])
    authorize! :update, @label_layout

    respond_to do |format|
      if @label_layout.update_attributes(label_layout_params)
        format.html { redirect_to [:adm, @label_layout], notice: 'LabelLayout was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # # DELETE /admin/label_layouts/1
  # # DELETE /admin/label_layouts/1.json
  # def destroy
  #   @label_layout = LabelLayout.find(params[:id])
  #   authorize! :destroy, @label_layout

  #   respond_to do |format|
  #     if @label_layout.destroy
  #       format.html { redirect_to adm_label_layouts_url, notice: "LabelLayout #{@label_layout.name} destroyed." }
  #     else
  #       format.html { redirect_to [:adm, @label_layout], notice: 'Could not destroy label layout' }
  #     end
  #   end
  # end

 private

  def label_layout_params
    params.require(:label_layout).permit(:name, :description, :pw, :ph, :mt, :mr, :mb, :ml, :nr, :nc, :vs, :hs, :page)
  end

end
