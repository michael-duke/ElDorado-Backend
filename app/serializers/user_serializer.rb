class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email
  attribute :role, if: :admin?

  delegate :admin?, to: :object
end
