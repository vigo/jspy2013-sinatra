# encoding: utf-8
require 'rubygems'
require 'bundler/setup'
require 'test/unit'
require 'rack/test'

OUTER_APP = Rack::Builder.parse_file('config.ru').first

class TestApp < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    OUTER_APP
  end

  def test_sample_page
    get '/test/amacli/1/'
    assert last_response.ok?
    assert_equal "JsPyConf çok güzel!", last_response.body
  end
end