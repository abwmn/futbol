require './spec/spec_helper'

RSpec.describe Games do
  before(:all) do
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }

    @game_teams = GameTeams.new(locations)
    @games = Games.new(locations)
    @teams = League.new(locations)
  end

  describe 'games' do
    it 'exists with attributes' do
      expect(@games).to be_a(Games)
    end
  end

  describe 'highest_total_score and lowest_total_score' do
    it 'highest_total_score' do
      expect(@games.highest_total_score).to eq(11)
    end
    
    it 'lowest_total_score' do
      expect(@games.lowest_total_score).to eq(0)
    end
  end

  describe 'average_goals_by_season and average_goals_per_game' do
    it 'average_goals_by_season' do
      expect(@games.average_goals_by_season).to eq({'20122013'=>4.12,
                                                    '20162017'=>4.23, 
                                                    '20142015'=>4.14, 
                                                    '20152016'=>4.16, 
                                                    '20132014'=>4.19, 
                                                    '20172018'=>4.44})
    end

    it 'average_goals_per_game' do
      expect(@games.average_goals_per_game).to eq(4.22)
    end
  end

  describe 'percent_home_wins, percent_away_wins, percent_ties' do
    it 'percent_home_wins' do
      expect(@games.percent_home_wins).to eq(0.44)
    end

    it 'percent_away_wins' do
      expect(@games.percent_away_wins).to eq(0.36)
    end

    it 'percent_ties' do
      expect(@games.percent_ties).to eq(0.20)
    end
  end

  describe 'count_of_games_by_season' do
    it 'count_of_games_by_season' do
      expect(@games.count_of_games_by_season).to eq({'20122013'=>806, 
                                                     '20162017'=>1317, 
                                                     '20142015'=>1319, 
                                                     '20152016'=>1321, 
                                                     '20132014'=>1323, 
                                                     '20172018'=>1355})
    end
  end
  describe 'seasonal_summary' do
    it 'seasonal_summary' do
      expect(@games.seasonal_summary('1')).to be_a(Hash)
      expect(@games.seasonal_summary('1')['20122013'][:regular_season]).to eq({
        :average_goals_against=>1.96, 
        :average_goals_scored=>1.96, 
        :games=>48, 
        :total_goals_against=>94, 
        :total_goals_scored=>94, 
        :win_percentage=>0.333, 
        :wins=>16})
      expect(@games.seasonal_summary('54')['20172018'][:regular_season]).to eq({
        :average_goals_against=>2.21, 
        :average_goals_scored=>2.34, 
        :games=>82, 
        :total_goals_against=>181, 
        :total_goals_scored=>192, 
        :win_percentage=>0.476, 
        :wins=>39})
      expect(@games.seasonal_summary('54')['20172018'][:postseason]).to eq({
        :average_goals_against=>1.75, 
        :average_goals_scored=>2.35, 
        :games=>20, 
        :total_goals_against=>35, 
        :total_goals_scored=>47, 
        :win_percentage=>0.6, 
        :wins=>12})

      expect(@games.seasonal_summary('54')['20172018'][:regular_season][:total_goals_scored]).to eq(192)
      expect(@games.seasonal_summary('54')['20172018'][:regular_season][:total_goals_against]).to eq(181)
      expect(@games.seasonal_summary('54')['20172018'][:regular_season][:wins]).to eq(39)
    end
  end
end