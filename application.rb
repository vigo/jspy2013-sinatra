# encoding: utf-8

require 'rubygems'
require 'bundler'
Bundler.require
# require 'bundler/setup'
# require 'sinatra/base'
require 'json'

class MyApp < Sinatra::Base
  helpers do
    def h(text)
      Rack::Utils.escape_html(text)
    end
  end

  # default sayfa...
  # --------------------------------------------------------------------------
  get '/' do
    "Merhaba Dünya! saat: #{Time.now}"
  end
  # --------------------------------------------------------------------------


  # --------------------------------------------------------------------------
  get '/merhaba/:user_name' do
    "Merhaba #{params[:user_name]}!"
  end
  get '/merhaba/*/numaran/*' do
    "#{params[:splat][0]}, #{params[:splat][1]}"
  end
  # --------------------------------------------------------------------------


  # --------------------------------------------------------------------------
  get '/indir/*.*' do |file, ext|
    "Dosya: #{file}, Tipi: #{ext}"
  end
  # --------------------------------------------------------------------------


  # regexp...
  # --------------------------------------------------------------------------
  get %r{/kullanici/([\w]+)/?(\d+)?} do
    "Yakalananlar: #{params[:captures]}"
  end
  # --------------------------------------------------------------------------


  # --------------------------------------------------------------------------
  get '/kazanan/:user/?:id?' do
    "Kazanan #{params[:user]}, id var mı? #{!params[:id].nil?}"
  end
  # --------------------------------------------------------------------------


  # AppleWebKit/536.28.10
  # Sadece AppleWebKit tarayıcıları için :agent örneği
  # --------------------------------------------------------------------------
  get '/ajan', :agent => /AppleWebKit\/(\d+)/ do
    mversion = @params[:agent].first
    "AppleWebKit major sürümü: #{mversion}"
  end
  get '/ajan' do
    "Tüm tarayıcılar için..."
  end
  # --------------------------------------------------------------------------


  # request nesenesinde neler var?
  # --------------------------------------------------------------------------
  get '/request' do
    out = []
    [
      'accept',
      'scheme',
      'script_name',
      'path_info',
      'port',
      'request_method',
      'query_string',
      'content_length',
      'media_type',
      'host',
      'referrer',
      'user_agent',
      'cookies',
      'url',
      'path',
      'ip',
      'xhr?',
      'secure?',
      'forwarded?',
    ].each do |m|
      out << "<strong>%s</strong>: %s" % [m, request.send(m)]
    end
    out << "<hr/>env<hr/>"
    request.env.each do |k,v|
      out << "<strong>%s</strong>: %s" % [k, v]
    end
    "#{out.join('<br/>')}"
  end
  # --------------------------------------------------------------------------


  # :host_name, :provides ve custom condition örnekleri
  # --------------------------------------------------------------------------
  get '/admin', :host_name => /^local/ do
    "Sadece adminler girebilir!"
  end
  
  get '/test_provide', :provides => :json do
    pass unless request.accept? 'application/json'
    { :username => 'vigo', :email => 'hello@jspyconf.org' }.to_json
  end

  set(:ihtimal) { |value| condition { rand <= value } }
  get '/piyango', :ihtimal => 0.1 do
    "Tebrikler kazandınız!"
  end
  get '/piyango' do
    "Kaybettiniz ):"
  end
  # --------------------------------------------------------------------------


  # sadece test amaçlı
  # --------------------------------------------------------------------------
  class TestUser
    attr_reader :roles
    def initialize
      @roles = [:user, :guest]
    end
    def in_role?(role)
      [:user].member?(role)
    end
  end
  current_test_user = TestUser.new
  set(:test_auth) do |*roles|
    condition do
      unless roles.any? {|role| current_test_user.in_role? role }
        redirect "/sistem/giris", 303
      end
    end
  end
  get "/sistem/giris/?" do
    "Bu sayfaları görüntülemek için sisteme giriş yapmanız gerekiyor!"
  end
  get "/sistem/profil/?", :test_auth => [:user, :guest] do
    "Profil bilgileri"
  end
  get "/sistem/admin/?", :test_auth => :admin do
    "Sadece admin olanlar görebiliyor"
  end
  # --------------------------------------------------------------------------


  # view, layout ve template örnekleri
  # --------------------------------------------------------------------------
  # sass
  # --------------------------------------------------------------------------
  get '/sass/*.sass' do
    content_type 'text/css', :charset => 'utf-8'
    sass params[:splat].first.to_sym,
         :style => :expanded,
         :views => "#{settings.root}/sass"
  end
  # --------------------------------------------------------------------------


  # inline Markdown ve sass örneği
  # --------------------------------------------------------------------------
  get '/sayfa/ornek/markdown/?' do
    markdown :sayfa, :layout_engine => :erb, :layout => :genel3
  end
  # --------------------------------------------------------------------------


  # --------------------------------------------------------------------------
  get '/sayfa/?' do
    @saat = Time.now.strftime("%I:%M:%S")
    erb :sayfa
  end

  get '/sayfa/2/?' do
    @saat = Time.now.strftime("%I:%M:%S")
    @page_title = "Bu sayfa :layout kullanıyor"
    erb :sayfa, :layout => :genel
  end
  
  before '/sayfa/3/?' do
    @before_param = "Bu değişken -before- da set edildi"
  end
  get '/sayfa/3/?' do
    @saat = Time.now.strftime("%I:%M:%S")
    @page_title = "Bu sayfa :layout ve css kullanıyor"
    erb :sayfa, :layout => :genel2
  end
  get '/sayfa/4/?' do
    @saat = Time.now.strftime("%I:%M:%S")
    @page_title = "template string olarak geçildi..."
    erb :"sayfa", :layout => :genel2
  end
  # --------------------------------------------------------------------------

  # --------------------------------------------------------------------------
  get '/post/test/?' do
    erb :post_form, :layout => :genel
  end
  post '/post/test/?' do
    @username = params[:username]
    erb :post_form, :layout => :genel
  end
  # --------------------------------------------------------------------------

  # pass
  # --------------------------------------------------------------------------
  get '/tahmin/:kim/?' do
    pass unless params[:kim] == 'vigo'
    "Doğru cevap!"
  end
  get '/tahmin/*/?' do
    "Hayır bilemedin!"
  end
  # --------------------------------------------------------------------------
  
  
  # halt
  # --------------------------------------------------------------------------
  get '/konferans1/:hangisi/?' do
    halt unless params[:hangisi] == 'jspyconf'
    "Evet doğru konferans!"
  end
  get '/konferans2/:hangisi/?' do
    halt 404 unless params[:hangisi] == 'jspyconf'
    "Evet doğru konferans!"
  end
  get '/konferans3/:hangisi/?' do
    halt [403, "Yetkiniz yok"] unless params[:hangisi] == 'jspyconf'
    "Evet doğru konferans!"
  end
  
  not_found do
    "Aradığınız sayfa bulunamadı!"
  end
  # --------------------------------------------------------------------------
  
  
  # redirect
  # --------------------------------------------------------------------------
  get '/google' do
    redirect "http://google.com"
  end
  # --------------------------------------------------------------------------

  # custom error handler
  # --------------------------------------------------------------------------
  
  # disable :raise_errors
  disable :show_exceptions
  error do
    mesaj = env['sinatra.error'].message
    "Hata mesajı: <strong>#{mesaj}</strong>"
  end
  class CustomError < StandardError; end
  error CustomError do
    mesaj = env['sinatra.error'].message
    "Bu <strong>CustomError</strong>,
      mesajı da <strong>#{mesaj}</strong>"
  end

  get '/ozel-hata/1/' do
    raise StandardError, "StandardError raise ettik"
  end
  get '/ozel-hata/2/' do
    raise CustomError, "CustomError raise ettik"
  end
  # --------------------------------------------------------------------------

  # rack/test için...
  # --------------------------------------------------------------------------
  get '/test/amacli/1/?' do
    "JsPyConf çok güzel!"
  end
  # --------------------------------------------------------------------------

  run! if app_file == $0
end