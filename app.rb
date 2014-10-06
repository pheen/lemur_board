require 'angelo'
require 'angelo/mustermann'
require 'tilt/haml'
require 'ohm'
require 'awesome_print'
require 'byebug'

class Lemur < Angelo::Base
  include Angelo::Mustermann

  get '/assets/(?<path>.*)', type: :regexp do
    responder.headers['Content-Type'] = case params[:path]
      when /\.js$/
        'application/javascript'
      when /\.css$/
        'text/css'
    end
    dir = params[:path] =~ /libraries/ ? 'app/assets' : 'build'

    File.read("#{dir}/#{params[:path]}")
  end

  get '/' do
    template = Tilt::HamlTemplate.new('app/views/layout.haml')
    template.render
  end
end

Lemur.run
