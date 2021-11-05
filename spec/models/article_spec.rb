# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Article, type: :model do
  let(:user) do
    User.create(
      username: 'johndoe',
      password: 'abc123',
      info: 'Software developer'
    )
  end

  subject do
    described_class.new(
      title: 'Anything',
      body: 'Lorem ipsum',
      status: 'public',
      user_id: user.id
    )
  end

  describe 'title' do
    it 'should be present' do
      subject.title = nil
      expect(subject).not_to be_valid
    end

    it 'cannot be blank' do
      subject.title = ''
      expect(subject).not_to be_valid
    end
  end

  describe 'body' do
    it 'should be present' do
      subject.body = nil
      expect(subject).not_to be_valid
    end

    it 'should have a minimum length of 10' do
      subject.body = 'lorem'
      expect(subject).not_to be_valid
      subject.body = 'lorem ipsum'
      expect(subject).to be_valid
    end
  end

  describe 'status' do
    it 'should be present' do
      subject.status = nil
      expect(subject).not_to be_valid
    end
  end

  describe 'user_id' do
    it 'should be present' do
      subject.user_id = nil
      expect(subject).not_to be_valid
    end

    it 'should represent an existent user' do
      subject.user_id = 0
      expect(subject).not_to be_valid
    end
  end

  context 'with valid attributes' do
    it { is_expected.to be_valid }
  end
end
