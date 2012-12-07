class QueriesController < ApplicationController
  def new
    @query = Query.new(sql_query: params[:sql_query]) || NullQuery.new
  end
end

