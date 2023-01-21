require 'rails_helper'

RSpec.describe Car, type: :model do
  before(:each) do
    @car = Car.create(
      name: 'Audi',
      image: 'https://www.audi.com/content/dam/gbp2/experience-audi/audi-models/a4-saloon/2021/1920x1080/1920x1080_A4_Saloon_2021_01.jpg',
      model: '2021',
      daily_price: 100,
      description: 'The Audi A4 is a line of compact executive cars produced since 1994
        by the German car manufacturer Audi, a subsidiary of the Volkswagen Group.
        The A4 has been built in five generations and is based on the Volkswagen Group B platform.'
    )
  end

  context 'When passing wrong parameters to the method' do
    it 'should not save the car no name' do
      @car.name = nil
      expect(@car).to_not be_valid
    end

    it 'should not save the car no image' do
      @car.image = nil
      expect(@car).to_not be_valid
    end

    it 'should not save the car no model' do
      @car.model = nil
      expect(@car).to_not be_valid
    end

    it 'should not save the car no daily_price' do
      @car.daily_price = nil
      expect(@car).to_not be_valid
    end
  end

  context 'When passing valid parameters to the method' do
    it 'should save the car' do
      expect(@car).to be_valid
    end
  end

  context 'When testing edge cases with the method' do
    it 'name should not exceed maximum length' do
      @car.name = 'a'
      expect(@car).to_not be_valid
    end

    it 'name should not be less tham minimum length' do
      @car.name = 'a'
      expect(@car).to_not be_valid
    end

    it 'model should not exceed maximum length' do
      @car.model = 'a'
      expect(@car).to_not be_valid
    end

    it 'description should not be less tham minimum length' do
      @car.description = 'a'
      expect(@car).to_not be_valid
    end

    it 'image should not be less tham minimum length' do
      @car.image = 'a'
      expect(@car).to_not be_valid
    end
  end

  context 'Testing Associations' do
    it 'has_many bookings' do
      assoc = Car.reflect_on_association(:bookings)
      expect(assoc.macro).to eq :has_many
    end

    it 'has_many cars through bookings' do
      assoc = Car.reflect_on_association(:users)
      expect(assoc.macro).to eq :has_many
    end
  end
end
