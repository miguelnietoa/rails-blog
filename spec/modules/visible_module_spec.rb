require 'rails_helper'


RSpec.describe Visible do
  let(:user) do
    User.create(
      username: 'johndoe',
      password: 'abc123',
      info: 'Software developer'
    )
  end

  let(:article_params) do
    {
      title: 'Anything',
      body: 'Lorem ipsum',
      status: 'public',
      user_id: user.id
    }
  end

  describe 'class_method public_count' do
    it 'should return public count' do
      Article.create(article_params)  # public
      Article.create(article_params.merge(status: 'private')) # private
      Article.create(article_params.merge(status: 'archived'))  # archived
      expect(Article.public_count).to eq(1)
    end
  end

  describe '#archived?' do
    context 'when status is archived' do
      it 'should return true' do
        article = Article.create(article_params.merge(status: 'archived'))  # archived
        expect(article.archived?).to be true
      end
    end

    context 'when status is not archived' do
      it 'should return false' do
        article = Article.create(article_params)  # public
        expect(article.archived?).to be false

        article = Article.create(article_params.merge(status: 'private'))  # private
        expect(article.archived?).to be false
      end
    end
  end

  describe 'included validation' do
    context 'when status is not public/private/archived' do
      it 'should not be valid' do
        article = Article.new(article_params.merge(status: 'a'))  # invalid
        expect(article).not_to be_valid
      end
    end
  end
end
