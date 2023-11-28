require './fare_constants'

RSpec.describe FareConstants do
  describe 'CENTRAL_AIRPORT_FARE' do
    it 'contains the correct fare for adult' do
      expect(FareConstants::CENTRAL_AIRPORT_FARE['adult']).to eq(200)
    end

    it 'contains the correct fare for senior citizen' do
      expect(FareConstants::CENTRAL_AIRPORT_FARE['senior_citizen']).to eq(100)
    end

    it 'contains the correct fare for kid' do
      expect(FareConstants::CENTRAL_AIRPORT_FARE['kid']).to eq(50)
    end
  end

  describe 'LOW_BALANCE_CHARGE' do
    it 'has the correct low balance charge' do
      expect(FareConstants::LOW_BALANCE_CHARGE).to eq(0.02)
    end
  end

  describe 'TRIP_DISCOUNT' do
    it 'has the correct trip discount' do
      expect(FareConstants::TRIP_DISCOUNT).to eq(0.5)
    end
  end
end
