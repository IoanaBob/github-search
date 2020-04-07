# frozen_string_literal: true

class GithubSearchController < ApplicationController
  def index
    @params_with_defaults = GithubRepo.github_search_params_with_defaults(github_search_params)
    @github_repos = GithubRepo.all(github_search_params)
  end

  private

  def github_search_params
    params.permit[:github_search] && params[:github_search]&.permit(:search, :sort, :order)
  end
end
