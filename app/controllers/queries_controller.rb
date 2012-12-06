class QueriesController < ApplicationController
  def new
    binding.pry
    @query = Query.new(ar_query: params[:ar_query]) || NullQuery.new
  end
end

