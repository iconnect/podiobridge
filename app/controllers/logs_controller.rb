class LogsController < ApplicationController

  def index
    @logs = Log.all.order("created_at desc").limit(30)
  end

end
