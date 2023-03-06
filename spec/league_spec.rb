require 'csv'
require 'rspec'
require './spec/spec_helper'

RSpec.describe League do
  before(:all) do
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }

    @league = League.new(locations)
  end

  describe 'league' do
    it 'exists with attributes' do
      expect(@league).to be_a(League)
      expect(@league.team_id).to be_a(Array)
      expect(@league.team_info("18")).to be_a(Hash)
    end
  end
end