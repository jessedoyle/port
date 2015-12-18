require 'rails_helper'

describe PageDecorator do
  describe 'other_visibility' do
    it 'returns Public when visibility is private' do
      page = create(:page).decorate
      expect(page.other_visibility).to eq('Public')
    end

    it 'returns Private when visibility is public' do
      page = create(:page).decorate
      page.toggle_visibility!
      expect(page.other_visibility).to eq('Private')
    end
  end

  describe 'visibility' do
    it 'returns Private when visibility is private' do
      page = create(:page).decorate
      expect(page.visibility).to eq('Private')
    end

    it 'returns Public when visibility is public' do
      page = create(:page).decorate
      page.toggle_visibility!
      expect(page.visibility).to eq('Public')
    end
  end
end
