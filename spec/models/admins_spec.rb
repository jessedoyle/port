require 'rails_helper'

describe Admin do
  describe 'initialize' do
    context 'valid' do
      it 'builds instances' do
        admin = build(:admin)
        expect(admin).to be_valid
        expect(admin).to be_a_new(Admin)
      end

      it 'create instances' do
        admin = create(:admin)
        expect(admin).to be_a(Admin)
        expect(admin).to be_valid
        expect(admin.new_record?).to be_falsey
      end
    end

    context 'invalid' do
      it 'requires an email address' do
        admin = Admin.new(password: '12345678', password_confirmation: '12345678')
        expect(admin.valid?).to be_falsey
        expect(admin.errors.first).to eq([:email, 'can\'t be blank'])
        expect(admin.errors.size).to eq(1)
      end

      it 'requires a valid email address' do
        admin = Admin.new(email: 'test()()()()', password: '12345678', password_confirmation: '12345678')
        expect(admin.valid?).to be_falsey
        expect(admin.errors.first).to eq([:email, 'is invalid'])
        expect(admin.errors.size).to eq(1)
      end

      it 'requires a password' do
        admin = Admin.new(email: 'test@super.com')
        expect(admin.valid?).to be_falsey
        expect(admin.errors.first).to eq([:password, 'can\'t be blank'])
        expect(admin.errors.size).to eq(1)
      end

      it 'requires a matching password confirmation' do
        admin = Admin.new(email: 'test@super.com', password: '12345678', password_confirmation: '87654321')
        expect(admin.valid?).to be_falsey
        expect(admin.errors.first).to eq([:password_confirmation, 'doesn\'t match Password'])
        expect(admin.errors.size).to eq(1)
      end

      it 'requires a password of at least 8 characters' do
        admin = Admin.new(email: 'test@super.com', password: '1234', password_confirmation: '1234')
        expect(admin.valid?).to be_falsey
        expect(admin.errors.first.first).to eq(:password)
        expect(admin.errors.first.last).to match(/is too short/)
        expect(admin.errors.size).to eq(1)
      end

      it 'requires a unique email address' do
        create(:admin)
        admin = Admin.new(attributes_for(:admin))
        expect(admin.valid?).to be_falsey
        expect(admin.errors.first).to eq([:email, 'has already been taken'])
        expect(admin.errors.size).to eq(1)
      end
    end
  end
end
