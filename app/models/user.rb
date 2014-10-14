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
      email: email,
      first_name: first_name,
      last_name: last_name,
      img: img
    }
  end

  def login(password)
    password_hash == password
  end

end
