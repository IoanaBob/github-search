# frozen_string_literal: true

class GithubRepo
  include ActiveModel::Model

  attr_accessor :name, :full_name, :owner_name, :description, :language, :stars

  SEARCH_DEFAULTS = { page: 1, per_page: 50, sort: 'stars', order: 'desc' }.freeze

  class << self
    def all(query_params)
      params_with_defaults = github_search_params_with_defaults(query_params)
      response = HTTParty.get(github_search_url(params_with_defaults))
      response_body = JSON.parse(response.body)
      map_github_repos_response(response_body['items'])
    end

    def github_search_params_with_defaults(params)
      params ||= {}
      SEARCH_DEFAULTS.merge(params.to_h.symbolize_keys)
    end

    private

    def github_search_url(params)
      search_url = 'https://api.github.com/search/repositories?q='
      search_url += "#{params[:search]} in:name+" if params[:search].present?
      search_url += "stars:>=0&page=#{params[:page]}&per_page=#{params[:per_page]}" \
              "&sort=#{params[:sort]}&order=#{params[:order]}"
    end

    def map_github_repos_response(repos)
      repos.map do |repo|
        GithubRepo.new(
          name: repo['name'],
          full_name: repo['full_name'],
          owner_name: repo['owner']['login'],
          description: repo['description'],
          language: repo['language'],
          stars: repo['stargazers_count']
        )
      end
    end
  end
end
