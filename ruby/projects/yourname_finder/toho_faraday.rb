require 'faraday'
require 'pry'

class Cinema < Faraday::Middleware
  def call(req_env)
  end

  def get
  end

  class Toho < Cinema
    def call(req_env)
      p "toho_req"
      @app.call(req_env).on_complete do |res_env|
        p "toho_res"
      end
    end
  end
  
  class Piccadilly < Cinema 
    def call(req_env)
      p "piccadilly_req"
      @app.call(req_env).on_complete do |res_env|
        p "piccladilly_req"
      end
    end
  end
  
  class Wald9 < Cinema 
    def call(req_env)
      p "wald_req"
      @app.call(req_env).on_complete do |res_env|
        p "wald_req"
      end
    end
  end
end

Faraday::Request.register_middleware(toho: Cinema::Toho)
Faraday::Response.register_middleware(piccadilly: Cinema::Piccadilly) 
Faraday::Middleware.register_middleware(wald9: Cinema::Wald9)

connection_toho = Faraday.new('https://hlo.tohotheater.jp') do |conn|
  conn.request :toho
end
connection_piccadilly = Faraday.new('https://ticket.smt-cinema.com') do |conn|
  conn.response :piccadilly
end
connection_wald9 = Faraday.new('http://exmaple.com') do |conn|
  conn.use :wald9
end

connection_toho.get '/net/ticket/076/TNPI2040J03'
connection_piccadilly.get '/ticket/f0100.do?th=1051&mo=18210&sd=20160927&pe=3&sc=02&fl=0'
connection_wald9.get '/'
