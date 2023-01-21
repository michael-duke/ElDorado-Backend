class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email
  attribute :role, if: :admin?

  def admin?
    object.admin?
  end
end
