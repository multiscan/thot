class LoansController < ApplicationController
  # POST /loans
  # POST /loans.json
  def create
    respond_to do |format|
      if @user = nebis_user
        @loan = Loan.checkout(@user, params[:loan]["inv"]||params[:loan]["item_id"].to_i)
        if @loan && @loan.save
          format.html { redirect_to @user, notice: 'Item was successfully checked out' }
          format.json { render json: @loan }
          format.js
          # format.js do
          #   render :inline do |page|
          #     page.insert_html :bottom, :booklist, :partial => 'loan', :object => @loan
          #   end
          # end
             # js: "$('page').insert_html :bottom, :booklist, :partial => 'loan', :object => @loan"}
          # format.js { render js: "$('page').insert_html :bottom, :booklist, :partial => 'loan', :object => @loan"}
          # format.js { render js: "alert('ciao mona');"}
          # $(page).insert_html :bottom, :booklist,
        else
          format.html { redirect_to @user, error: "An error occurred while checking out the requested item" }
          format.json { render json: @loan.errors, status: :unprocessable_entity }
          format.js
        end
      else
        format.html { redirect_back_or_root(error: "In ordero to be able to check in/out books, please identify yourself by scanning your Nebis code first.")}
        format.json { render json: @loan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /loans/1
  # DELETE /loans/1.json
  def destroy
    @loan = Loan.find(params[:id])
    respond_to do |format|
      @user = nebis_user
      if @user.id == @loan.user_id
        if @loan.checkin
          format.html { redirect_to users_url }
          format.json { head :no_content }
          format.js
        else
          format.html { redirect_to users_url, :error=>"Error while returning item #{@loan.item.id}" }
          format.json { head :no_content }
          format.js { render :js => 'add_alert("error", "Error while returning item #{@loan.item.id}");', :status => :internal_server_error }
        end
      else
        format.html { redirect_to users_url, :error=>"Error while returning item #{@loan.item.id}" }
        format.json { head :no_content }
        format.js { render :js => 'add_alert("error", "Forbidden.");', :status => :forbidden }
      end
    end
  end

end
