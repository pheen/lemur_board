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
      id: id,
      challenger_id: challenger_id,
      opponent_id: opponent_id,
      timestamp: timestamp,
      accepted: accepted
    }
  end

  def self.all_public_attributes
    all.sort(by: :timestamp).map(&:public_attributes)
  end

  def self.issue(attrs)
    challenger_email = attrs.fetch('challenger_email') { return false }
    opponent_email   = attrs.fetch('opponent_email')   { return false }
    timestamp        = attrs.fetch('time')  { return false }

    challenger = User.find(email: challenger_email).first
    opponent   = User.find(email: opponent_email).first

    challenge = create(
      challenger_id: challenger.id,
      opponent_id: opponent.id,
      timestamp: timestamp,
      accepted: false
    )

    # stopped here
    if challenge
      # email opponent notification with calendar invite
    end

    challenge.public_attributes
  end

end
