require 'rack'
require_relative '../lib/controller_base'

class ControllerBase 

  def initialize(req, res)
    @req = req 
    @res = res
  end

  def render_content(content, content_type="text/html")
    @res['Content-Type'] = content_type
    @res.write(content) 

    @already_built_response = true
  end

  def redirect_to(url)
    @res.status = 302
    @res.location = url 

    @already_built_response = true
  end
end

class MyController < ControllerBase
  def go
    if req.path == "/cats"
      render_content("hello cats!", "text/html")
    else
      redirect_to("/cats")
    end
  end
end

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  MyController.new(req, res).go
  res.finish
end

Rack::Server.start(
  app: app,
  Port: 3000
)

