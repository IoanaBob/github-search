# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GithubSearches', type: :request do
  describe 'GET /github_search' do
    before do
      allow(GithubRepo).to receive(:all).and_return(github_repos_response)
      get '/github_search', params: params
    end

    let(:github_repos_response) do
      [
        GithubRepo.new(
          name: 'githubsearch',
          full_name: 'ioanabob/githubsearch',
          owner_name: 'ioanabob',
          description: 'Lorem ipsum dolor sit amet',
          language: 'ruby',
          stars: '47'
        ),
        GithubRepo.new(
          name: 'notsearch',
          full_name: 'ioanabob/notsearch',
          owner_name: 'ioanabob',
          description: 'Lorem ipsum dolor sit amet',
          language: 'elixir',
          stars: '49'
        )
      ]
    end

    let(:params) { { github_search: { search: 'hi' } } }

    it 'returns github repos' do
      expect(response.body).to include('ioanabob/githubsearch')
      expect(response.body).to include('ioanabob/notsearch')
    end

    it 'sends params to the api model' do
      expect(GithubRepo).to have_received(:all)
    end
  end
end
