# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GithubRepo do
  describe '#all' do
    subject { described_class.all(search_params) }

    before do
      allow(HTTParty).to receive(:get).and_return(github_response)
      allow(JSON).to receive(:parse).and_return(github_response_body)
    end

    let(:github_response) { instance_double(HTTParty::Response, body: 'response_body') }
    let(:github_response_body) do
      {
        'items' => [
          {
            'name' => expected_repo.name,
            'full_name' => expected_repo.full_name,
            'owner' => {
              'login' => expected_repo.owner_name
            },
            'description' => expected_repo.description,
            'language' => expected_repo.language,
            'stargazers_count' => expected_repo.stars
          }
        ]
      }
    end

    let(:expected_repo) do
      GithubRepo.new(
        name: 'githubsearch',
        full_name: 'ioanabob/githubsearch',
        owner_name: 'ioanabob',
        description: 'Lorem ipsum dolor sit amet',
        language: 'ruby',
        stars: '47'
      )
    end

    context 'with no search parameters' do
      let(:search_params) { {} }

      it 'fetches the repos from Github api using default params' do
        subject
        github_url = 'https://api.github.com/search/repositories?q=stars:>=0' \
                     '&page=1&per_page=50&sort=stars&order=desc'

        expect(HTTParty).to have_received(:get).with(github_url)
      end

      it 'parses the Github response' do
        subject
        expect(JSON).to have_received(:parse)
      end

      it 'presents the information in the correct format' do
        expect(subject.first.instance_values).to eq(expected_repo.instance_values)
      end
    end

    context 'with query search parameter' do
      let(:search_params) { { search: 'hello' } }

      it 'fetches the repos from Github api using default params' do
        subject
        github_url = 'https://api.github.com/search/repositories?q=hello in:name+stars:>=0' \
                     '&page=1&per_page=50&sort=stars&order=desc'

        expect(HTTParty).to have_received(:get).with(github_url)
      end
    end

    context 'with custom ordering and sorting' do
      let(:search_params) { { sort: 'created', order: 'asc' } }

      it 'fetches the repos from Github api using default params' do
        subject
        github_url = 'https://api.github.com/search/repositories?q=stars:>=0' \
                     '&page=1&per_page=50&sort=created&order=asc'

        expect(HTTParty).to have_received(:get).with(github_url)
      end
    end
  end

  describe '#github_search_params_with_defaults' do
    subject { described_class.github_search_params_with_defaults(search_params) }
    context 'with no search parameters' do
      let(:search_params) { {} }

      let(:expected_result) { { order: 'desc', page: 1, per_page: 50, sort: 'stars' } }

      it { is_expected.to eq(expected_result) }
    end

    context 'with some params defined' do
      let(:search_params) { { order: 'asc', sort: 'created' } }

      let(:expected_result) { { order: 'asc', page: 1, per_page: 50, sort: 'created' } }

      it { is_expected.to eq(expected_result) }
    end

    context 'with all params defined' do
      let(:search_params) { { order: 'asc', page: 1, per_page: 50, sort: 'created' } }

      it { is_expected.to eq(search_params) }
    end
  end
end
