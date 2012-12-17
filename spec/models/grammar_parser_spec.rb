require 'spec_helper'
foo = File.join File.expand_path(File.dirname(__FILE__))
p foo
require'pry';binding.pry
require File.join File.expand_path(File.dirname(__FILE__)), 'node_extensions.vrb'

describe "QueryParser" do

  it "doesn't implode from simple SQL queries" do
    foo = []
    foo.push QueryParser.parse "SELECT user.name == 'bob' FROM users".downcase
    foo.push QueryParser.parse "SELECT * FROM users WHERE user.name == 'bob'".downcase
    foo.push QueryParser.parse 'select * from foo order by DESC'.downcase
    foo.push QueryParser.parse "select name,email FROM users".downcase
    foo.push QueryParser.parse "select * FROM joo".downcase
    foo.push QueryParser.parse "select * FROM name == 'foo'".downcase

    foo.each do |parse|
     parse.should be_an_instance_of Treetop::Runtime::SyntaxNode
    end
  end
end
