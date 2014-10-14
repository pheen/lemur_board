class Challenge < Ohm::Model
  attribute :challenger_id
  attribute :opponent_id
  attribute :timestamp
  attribute :accepted

  index :challenger_id
  index :opponent_id
  index :timestamp
  index :accepted

  def users
    User.find(id: [challenger_id, opponent_id])
  end

  def challenger
    User.find(id: challenger_id).first
  end

  def opponent
    User.find(id: opponent_id).first
  end

  def time
    Time.at(timestamp)
  end

  def public_attributes
    {
      challenger_id: challenger_id,
      opponent_id: opponent_id,
      timestamp: timestamp,
      accepted: accepted
    }
  end

end
