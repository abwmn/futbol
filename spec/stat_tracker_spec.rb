require './lib/stat_tracker'

RSpec.describe StatTracker do
  before(:all) do
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }

    @stat_tracker = StatTracker.new(locations)
  end

  describe 'game_stats' do
    it 'highest_total_score' do
      expect(@stat_tracker.highest_total_score).to eq(11)
    end
    
    it 'lowest_total_score' do
      expect(@stat_tracker.lowest_total_score).to eq(0)
    end
  end
end