require 'spec_helper'

describe 'Home Requests' do
  subject { page }
  before :each do
    visit '/'
  end

  it 'has homepage with titles' do
    should have_selector "h1", text: "AR to SQL"
    should have_selector "h2", text: "A Rails Active Record to SQL query editor"
  end

  it 'has two textfields for SQL and AR' do
    should have_selector "input", name: "sql"
    should have_selector "input", name: "ar"
    should have_selector "input", type: "submit", name: "Convert"
  end

end


describe 'Transfers input from AR field to SQL field' do
  subject { page }
  before :each do
    visit '/'
  end

  it 'takes invalid query and spits itself back out in sql field' do
    fill_in 'sql_query', with:  'invalid_example_query'
    click_button "Convert"
    find_field("ar_query").value.should have_content 'invalid_example_query'
  end
end
