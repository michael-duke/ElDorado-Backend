require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { User.new(name: 'Saw Gerrera', email: 'saw@rebels.com', password: 'password') }

  context 'Testing Validations' do
    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    it 'is not valid without a name' do
      user.name = nil
      expect(user).to_not be_valid
    end

    it 'is not valid without email' do
      user.email = nil
      expect(user).to_not be_valid
    end

    it 'is not valid without password' do
      user.password = nil
      expect(user).to_not be_valid
    end

    it 'has a default role of 0 (standard user)' do
      user.save
      expect(user.role).to eq "user"
    end
  end

  context 'Testing Associations' do
    it 'has_many reservations' do
      assoc = User.reflect_on_association(:reservations)
      expect(assoc.macro).to eq :has_many
    end

    it 'has_many cars through reservations' do
      assoc = User.reflect_on_association(:cars)
      expect(assoc.macro).to eq :has_many
    end

    it 'has_many car_status_histories' do
      assoc = User.reflect_on_association(:car_status_histories)
      expect(assoc.macro).to eq :has_many
    end
  end
end