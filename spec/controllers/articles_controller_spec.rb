# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Articles', type: :request do
  let(:user) do
    User.create(
      username: 'johndoe',
      password: 'abc123',
      info: 'Software developer'
    )
  end

  let(:valid_attributes) do
    {
      title: 'Anything',
      body: 'Lorem ipsum',
      status: 'public',
      user_id: user.id
    }
  end

  describe 'GET #index' do
    it 'shows articles list' do
      article = Article.create(valid_attributes)
      get articles_url
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:index)
      expect(response.body).to include(article.title)
    end
  end

  describe 'GET #show' do
    it 'renders the information about an article' do
      article = Article.create(valid_attributes)
      get article_url(article)
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:show)
      expect(response.body).to include(article.title)
      expect(response.body).to include(article.body)
      expect(response.body).to include(user.username)
    end
  end

  describe 'GET #new' do
    context 'when user is not logged' do
      it 'redirects to login page' do
        get new_article_url
        expect(response).to redirect_to(login_url)
        expect(response).to have_http_status(:found) # 302
      end
    end

    context 'when user is logged' do
      it 'renders new article page' do
        params = {
          session: {
            username: user.username,
            password: user.password
          }
        }
        post login_url, params: params

        get new_article_url
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid article attributes' do
      it 'should create an article and redirect to that article page' do
        # Login
        params = {
          session: {
            username: user.username,
            password: user.password
          }
        }
        post login_url, params: params

        article_params = {
          article: {
            title: valid_attributes[:title],
            body: valid_attributes[:body],
            status: valid_attributes[:status]
          }
        }
        # Article's count should increment by 1
        expect { post articles_url, params: article_params }.to change { Article.count }.by(1)
        expect(response).to have_http_status(:found) # 302
        expect(response).to redirect_to(article_url(assigns(:article)))
      end
    end

    context 'with invalid article attributes' do
      it 'should not create article, and render new article page' do
        # Login
        params = {
          session: {
            username: user.username,
            password: user.password
          }
        }
        post login_url, params: params

        article_params = {
          article: {
            body: valid_attributes[:body],
            status: valid_attributes[:status]
          }
        }
        # Article's count should not increment
        expect { post articles_url, params: article_params }.not_to(change { Article.count })
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #edit' do
    let(:article) { Article.create(valid_attributes) }

    context 'when user is not logged' do
      it 'redirects to login page' do
        get edit_article_url(article)
        expect(response).to redirect_to(login_url)
        expect(response).to have_http_status(:found) # 302
      end
    end

    context 'when user is logged' do
      it 'renders edit article page' do
        params = {
          session: {
            username: user.username,
            password: user.password
          }
        }
        post login_url, params: params

        get edit_article_url(article)
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'GET #update' do
    let(:article) { Article.create(valid_attributes) }

    let(:article_params) do
      {
        article: {
          title: 'Hello, title changed',
          body: 'New body',
          status: 'public'
        }
      }
    end

    context 'when user is not logged' do
      it 'redirects to login page' do
        put article_url(article), params: article_params

        expect(response).to redirect_to(login_url)
        expect(response).to have_http_status(:found) # 302
      end
    end

    context 'when user is logged' do
      it 'update article and redirect to the article page' do
        params = {
          session: {
            username: user.username,
            password: user.password
          }
        }
        post login_url, params: params

        put article_url(article), params: article_params
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Hello, title changed')
        expect(response.body).to include('New body')
      end
    end
  end

  describe '#destroy' do
    let(:article) { Article.create(valid_attributes) }

    context 'when user is not logged' do
      it 'redirects to login page' do
        delete article_url(article)

        expect(response).to redirect_to(login_url)
        expect(response).to have_http_status(:found) # 302
      end
    end

    context 'when user is logged' do
      it 'deletes article and redirects to articles list' do
        params = {
          session: {
            username: user.username,
            password: user.password
          }
        }
        post login_url, params: params

        # Check if article is created
        get article_url(article)
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:show)

        # Article's count should decrement by 1
        expect { delete article_url(article) }.to change { Article.count }.by(-1)
        expect(response).to have_http_status(:found) # 302
        expect(response).to redirect_to(root_url)
      end
    end
  end
end
