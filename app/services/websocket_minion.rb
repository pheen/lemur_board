require 'json'

class WebSocketMinion
  class MinionError < StandardError; end

  def self.setup(open_sockets, ws, current_user)
    minion = WebSocketMinion.new(open_sockets, ws, current_user)
    minion.add_to_open_sockets
    minion.listen_to_socket
    minion.write_initial_data
  end

  def initialize(open_sockets, ws, current_user)
    @open_sockets = open_sockets
    @ws = ws
    @current_user = current_user
  end

  def add_to_open_sockets
    @open_sockets << @ws
  end

  def listen_to_socket
    @ws.on_message do |json|
      msg = JSON.parse(json)
      create_response_for(msg) and notify_open_sockets
    end
  end

  def write_initial_data
    @ws.write(initial_data.to_json)
  end

private

  def create_response_for(msg)
    @response = if msg['issueChallenge']
      Challenge.issue(msg['issueChallenge']) or raise MinionError, 'Failed to create challenge'
    end
  end

  def notify_open_sockets
    json = @response.to_json

    @open_sockets.each do |socket|
      socket.write(json)
    end
  end

  def initial_data
    {
      current_user: @current_user.public_attributes,
      users: User.all_public_attributes,
      challenges: Challenge.all_public_attributes
    }
  end

end
