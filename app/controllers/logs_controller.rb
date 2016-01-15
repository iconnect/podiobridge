class LogsController < ApplicationController

  def index
    params[:per_page] ||= 30
    # @logs = Log.all.order("created_at desc").limit(params[:per_page])
  end

end
