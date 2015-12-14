require 'rails_helper'

describe AccessKey do
  describe 'initialize' do
    it 'validates presence_of value' do
      key = AccessKey.new(expires_after: Date.today)
      expect(key.valid?).to be_falsey
      expect(key.errors.size).to eq(1)
      expect(key.errors.first).to eq([:value, 'can\'t be blank'])
    end

    it 'validates presence_of expires_after' do
      key = AccessKey.new(value: 'test___')
      expect(key.valid?).to be_falsey
      expect(key.errors.size).to eq(1)
      expect(key.errors.first).to eq([:expires_after, 'can\'t be blank'])
    end

    it 'validates uniqueness_of value' do
      AccessKey.create(value: 'in_database', expires_after: Date.today)
      key = AccessKey.new(value: 'in_database', expires_after: Date.today)
      expect(key.valid?).to be_falsey
      expect(key.errors.size).to eq(1)
      expect(key.errors.first).to eq([:value, 'has already been taken'])
    end

    it 'creates valid instances' do
      key = create(:access_key)
      expect(key.valid?).to be_truthy
      expect(key).to be_a(AccessKey)
      expect(key.new_record?).to be_falsey
    end

    it 'downcases the value to ensure case insensitivity' do
      key = AccessKey.create(value: 'SOME_CAPS_small', expires_after: Date.today)
      expect(key.new_record?).to be_falsey
      expect(key.valid?).to be_truthy
      expect(key.value).to eq('some_caps_small')
    end
  end

  describe 'expired?' do
    it 'returns true if the current date is after the expiration' do
      key = create(:expired_access_key)
      expect(key.expired?).to be_truthy
    end

    it 'returns false if current date is before expiration' do
      key = create(:access_key)
      expect(key.expired?).to be_falsey
    end
  end

  describe 'not_expired?' do
    it 'returns false if the current date is after the expiration' do
      key = create(:expired_access_key)
      expect(key.not_expired?).to be_falsey
    end

    it 'returns true if current date is before expiration' do
      key = create(:access_key)
      expect(key.not_expired?).to be_truthy
    end
  end
end
