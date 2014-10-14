require 'angelo'
require 'angelo/mustermann'
require 'tilt/haml'
require 'ohm'
require 'bcrypt'
require 'time'

require 'awesome_print'
require 'byebug'

Dir['./lib/*'].each { |file| require file }
Dir['./app/models/*'].each { |file| require file }

class Lemur < Angelo::Base
  include Angelo::Mustermann
  include AppHelper

  get '/' do
    logged_in? or redirect('/login')
    render('layout', current_user: current_user)
  end

  websocket '/' do |ws|
    logged_in? or redirect('/login')
    websockets << ws

    json = {
      current_user: current_user.public_attributes,
      users: (User.all.sort(by: :email).to_a - [current_user]).map(&:public_attributes),
      challenges: Challenge.all.sort(by: :timestamp).map(&:public_attributes)
    }.to_json

    ws.write(json)

    ws.on_message do |msg|
      msg = JSON.parse(msg)

      if attrs = msg['issueChallenge']
        email = attrs.fetch('email')
        time  = attrs.fetch('time')

        user_to_smite = User.find(email: attrs['email']).first
        timestamp = Time.parse(time).to_i

        challenge = Challenge.create(
          challenger_id: current_user.id,
          opponent_id: user_to_smite.id,
          timestamp: timestamp,
          accepted: false
        )

        websockets.each do |socket|
          socket.write({ newChallenge: challenge.public_attributes }.to_json)
        end
      end
    end
  end


  get '/assets/(?<path>.*)', type: :regexp do
    set_content_type
    File.read(asset_path(params[:path]))
  end


  get '/login' do
    render('login')
  end

  post '/login' do
    user = User.find(email: params['email']).first

    if user && user.login(params['password'])
      you_saw_nothing = BCrypt::Password.create("#{user.email}#{user.password_hash}")
      { email: params['email'], mystery: you_saw_nothing }.to_json
    else
      { error: 'NOPE' }.to_json
    end
  end
end

Lemur.run
