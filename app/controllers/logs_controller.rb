class LogsController < ApplicationController

  def index
    @logs = PbLogger.all
  end

end
