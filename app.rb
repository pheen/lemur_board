require 'angelo'
require 'angelo/mustermann'
require 'tilt/haml'
require 'ohm'
require 'bcrypt'
require 'time'

require 'byebug'
require 'awesome_print'

Dir['./lib/*'].each             { |file| require file }
Dir['./app/models/*'].each      { |file| require file }
Dir['./app/services/*'].each    { |file| require file }
Dir['./app/controllers/*'].each { |file| require file }

class Application < Angelo::Base
  include Angelo::Mustermann
  include AppHelper

  get '/' do
    logged_in? or redirect('/login')
    render('layout', current_user: current_user)
  end

  websocket '/' do |ws|
    logged_in? or redirect('/login')
    WebSocketMinion.setup(websockets, ws, current_user)
  end

  get '/login' do
    return redirect('/') if logged_in?
    render('login')
  end

  post '/login' do
    response = successful_login do |user|
      you_saw_nothing = BCrypt::Password.create("#{user.email}#{user.password_hash}")

      {
        email: params['email'], 
        mystery: you_saw_nothing
      }
    end

    response ||= { error: 'NOPE' }
    response.to_json
  end

end

Application.run
