class NebisController < ApplicationController
  # get /nebis/extend
  def extend
    nebis_extend
    respond_to do |format|
      if nebis_session
        format.html { params[:id]=nebis_user.id ; render :action => "show", :controller => "users" }
        format.json { render json: true }
      else
        format.html { redirect_back_or_root(:notice => "Could not extend your NEBIS session. Please rescan your card.")}
        format.json { render :json => {:status => false, :alert => render_to_string(:partial => "errore", :formats => [:html])}.to_json,  :status => :unprocessable_entity }
      end
    end
  end

end
