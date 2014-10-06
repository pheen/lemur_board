class User < Ohm::Model
  attribute :email
  attribute :password
  attribute :first_name
  attribute :last_name
  attribute :img

  index :email
  unique :email
end
