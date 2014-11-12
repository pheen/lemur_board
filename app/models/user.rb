class User < Ohm::Model
  attribute :email
  attribute :password_hash
  attribute :first_name
  attribute :last_name
  attribute :img

  index :email
  unique :email

  def challenges
    challenges_made.to_a | challenges_received.to_a
  end

  def challenges_made
    Challenge.find(challenger_id: id)
  end

  def challenges_received
    Challenge.find(opponent_id: id)
  end

  def public_attributes
    {
      id: id,
      email: email,
      first_name: first_name,
      last_name: last_name,
      img: img
    }
  end

  def login(password)
    password_hash == password
  end

  def self.all_public_attributes
    users = all.sort(by: :email).to_a.map(&:public_attributes)
    users.reduce({}) do |hash, user_attrs|
      hash[user_attrs[:id]] = user_attrs
      hash
    end
  end

end
