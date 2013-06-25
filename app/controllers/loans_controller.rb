class LoansController < ApplicationController
  # POST /loans
  # POST /loans.json
  def create
    respond_to do |format|
      if @user = nebis_user
        @loan = Loan.checkout(@user, params[:loan]["item_id"])
        if @loan && !@loan.new_record?
          format.html { redirect_to @user, notice: 'The item you tried to check out is already in your list.' }
          format.js { render :js => "thot.alert('notice', 'Item #{@loan.item_id} is already in your list.');"}
        elsif @loan && @loan.save
          format.html { redirect_to @user, notice: 'Item was successfully checked out' }
          format.js
        else
          format.html { redirect_to @user, error: "An error occurred while checking out the requested item" }
          format.js
        end
      else
        format.html { redirect_back_or_root(error: "In order to be able to check in/out books, please identify yourself by scanning your Nebis code first.")}
        format.js { render :js => "thot.alert('notice', 'In ordero to be able to check in/out books, please identify yourself by scanning your Nebis code first.');"}
      end
    end
  end

  # DELETE /loans/1
  # DELETE /loans/1.json
  def destroy
    @loan = Loan.find(params[:id])
    respond_to do |format|
      @user = nebis_user
      if @user && @user.id == @loan.user_id || admin_signed_in? && can?(:update, @loan.user)
        if @loan.checkin
          format.html { redirect_to @loan.user }
          format.js
        else
          format.html { redirect_to @loan.user, :error=>"Error while returning item #{@loan.item.id}" }
          format.js { render :js => 'thot.alert("error", "Error while returning item #{@loan.item.id}");', :status => :internal_server_error }
        end
      else
        format.html { redirect_to users_url, :error=>"Error while returning item #{@loan.item.id}" }
        format.js { render :js => 'thot.alert("error", "Forbidden.");', :status => :forbidden }
      end
    end
  end

end
