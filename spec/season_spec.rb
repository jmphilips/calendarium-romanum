require 'spec_helper'

describe CR::Season do
  CR::Seasons.each do |season|
    describe season do
      describe '#name' do
        it { expect(season.name).to have_translation }
      end
    end
  end

  describe 'indexing' do
    it 'is indexed by symbol' do
      expect(CR::Seasons[:lent]).to be CR::Seasons::LENT
    end
  end
end
