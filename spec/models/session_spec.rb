require 'rails_helper'

RSpec.describe Workout, type: :model do
  it { should belong_to(:user) }

  context '#create_jwt' do
    let(:subject) { Session.make! }

    context 'before_save' do
      it 'should create the token' do
        expect(subject.token).to be_present
      end
    end
  end

  context '#decode_jwt' do
    let(:subject) { Session.make! }

    context 'decode the created JWT' do
      it 'should return decoded token' do
        expect(subject.decode_jwt).to include("user" => hash_including("email" => subject.user.email))
      end
    end
  end

  context '#decode_jwt' do
    let(:subject) { Session.make!(expiry_at: Time.current - 3.years) }

    context 'invalid expiry_at' do
      it 'should return errors' do
        expect(subject.decode_jwt).to eq(false)
        expect(subject.errors.count).to eq(1)
      end
    end

    context 'invalid token' do
      before do
        subject.update(token: "invalid_token")
      end
     
      it 'should return errors' do
        expect(subject.decode_jwt).to eq(false)
        expect(subject.errors.count).to eq(1)
      end
    end
  end


end
