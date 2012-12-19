class QueriesController < ApplicationController

  def new
    @query = params[:sql_query] ? Query.new(sql_query: params[:sql_query]) : NullQuery.new
    respond_to do |format|
      format.html { render 'new' }
      format.js { render 'new' }
    end
  end

  def index
  end

end

