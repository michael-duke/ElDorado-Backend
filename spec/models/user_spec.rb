require 'rails_helper'

RSpec.describe User do
  let(:user) { described_class.new(name: 'Saw Gerrera', email: 'saw@rebels.com', password: 'password') }

  context 'when testing validations' do
    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    it 'is not valid without a name' do
      user.name = nil
      expect(user).not_to be_valid
    end

    it 'is not valid without email' do
      user.email = nil
      expect(user).not_to be_valid
    end

    it 'is not valid without password' do
      user.password = nil
      expect(user).not_to be_valid
    end

    it 'has a default role of 0 (standard user)' do
      user.save
      expect(user.role).to eq 'customer'
    end
  end

  context 'with associations' do
    it 'has_many reservations' do
      assoc = described_class.reflect_on_association(:reservations)
      expect(assoc.macro).to eq :has_many
    end

    it 'has_many cars through reservations' do
      assoc = described_class.reflect_on_association(:cars)
      expect(assoc.macro).to eq :has_many
    end

    it 'has_many car_status_histories' do
      assoc = described_class.reflect_on_association(:car_status_histories)
      expect(assoc.macro).to eq :has_many
    end
  end
end
