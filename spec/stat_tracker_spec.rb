require './spec/spec_helper'

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

    @stat_tracker = StatTracker.from_csv(locations)
  end

  describe 'game_stats' do
    it 'highest_total_score' do
      expect(@stat_tracker.highest_total_score).to eq(11)
    end
    
    it 'lowest_total_score' do
      expect(@stat_tracker.lowest_total_score).to eq(0)
    end

    it 'average_goals_by_season' do
      avg_goals = @stat_tracker.average_goals_by_season
      expect(avg_goals).to be_a(Hash)
      expect(avg_goals['20122013']).to eq(4.12)
      expect(avg_goals['20132014']).to eq(4.19)
    end

    it 'average_home_wins' do
      expect(@stat_tracker.percent_home_wins).to eq(0.44)
    end

    it 'average_away_wins' do
      expect(@stat_tracker.percent_away_wins).to eq(0.36)
    end

    it 'average_ties' do
      expect(@stat_tracker.percent_ties).to eq(0.20)
    end

    it 'count_of_games_by_season' do
      expect(@stat_tracker.count_of_games_by_season['20122013']).to eq(806)
    end

    it 'average_goals_per_game' do
      expect(@stat_tracker.average_goals_per_game).to eq(4.22)
    end
  end

  describe 'league_stats' do
    it 'count_of_teams' do
      expect(@stat_tracker.count_of_teams).to eq(32)
    end

    it 'best_offense' do
      expect(@stat_tracker.best_offense).to eq("Reign FC")
    end
    
    it 'worst_offense' do
      expect(@stat_tracker.worst_offense).to eq("Utah Royals FC")
    end

    it 'highest_scoring_visitor' do
      expect(@stat_tracker.highest_scoring_visitor).to eq("FC Dallas")
    end

    it 'lowest_scoring_visitor' do
      expect(@stat_tracker.lowest_scoring_visitor).to eq("San Jose Earthquakes")
    end

    it 'highest_scoring_home_team' do
      expect(@stat_tracker.highest_scoring_home_team).to eq("Reign FC")
    end

    it 'lowest_scoring_visitor' do
      expect(@stat_tracker.lowest_scoring_home_team).to eq("Utah Royals FC")
    end
  end

  describe 'season_stats' do
    it 'winningest_coach' do
      expect(@stat_tracker.winningest_coach('20132014')).to eq("Claude Julien")
      expect(@stat_tracker.winningest_coach('20142015')).to eq("Alain Vigneault")
    end

    it 'worst_coach' do
      expect(@stat_tracker.worst_coach('20132014')).to eq("Peter Laviolette")
    end

    it 'least_accurate team' do
      expect(@stat_tracker.least_accurate_team('20132014')).to eq("New York City FC")
    end

    it 'most_accurate team' do
      expect(@stat_tracker.most_accurate_team('20132014')).to eq("Real Salt Lake")
    end

    it 'most_tackles' do
      expect(@stat_tracker.most_tackles('20132014')).to eq("FC Cincinnati")
    end

    it 'least_tackles' do
      expect(@stat_tracker.least_tackles('20132014')).to eq("Atlanta United")
    end

    it "#team_info" do
      expected = {
        "team_id" => "18",
        "franchise_id" => "34",
        "team_name" => "Minnesota United FC",
        "abbreviation" => "MIN",
        "link" => "/api/v1/teams/18"
      }
  
      expect(@stat_tracker.team_info("18")).to eq expected
    end

    it "#best_season" do
      expect(@stat_tracker.best_season("6")).to eq "20132014"
    end

    it "#worst_season" do
      expect(@stat_tracker.worst_season("6")).to eq "20142015"
    end

    it "#average_win_percentage" do
      expect(@stat_tracker.average_win_percentage("6")).to eq 0.49
    end

    it "#most_goals_scored" do
      expect(@stat_tracker.most_goals_scored("18")).to eq 7
    end

    it "#fewest_goals_scored" do
      expect(@stat_tracker.fewest_goals_scored("18")).to eq 0
    end

    it "#favorite_opponent" do
      expect(@stat_tracker.favorite_opponent("18")).to eq "DC United"
    end
  
    it "#rival" do
      expect(@stat_tracker.rival("18")).to eq("Houston Dash").or(eq("LA Galaxy"))
    end

    it "blowout" do
      expect(@stat_tracker.biggest_team_blowout("18")).to eq(5)
      expect(@stat_tracker.biggest_team_blowout("54")).to eq(5)
      expect(@stat_tracker.biggest_team_blowout("3")).to eq(4)
    end

    it 'bust' do
      expect(@stat_tracker.worst_loss("18")).to eq(4)
      expect(@stat_tracker.worst_loss("54")).to eq(4)
      expect(@stat_tracker.worst_loss("3")).to eq(5)
    end

    it 'h2h' do
      atl_expected = {
          wins: 5,
          loss: 4,
          draws: 1,
          games: 10,
          win_pct: 0.5
      }
      expect(@stat_tracker.head_to_head("7")).to be_a(Hash)
      expect(@stat_tracker.head_to_head("24")["Reign FC"][:win_pct]).to be_a(Float)
      expect(@stat_tracker.head_to_head("18")["Utah Royals FC"][:win_pct]).to eq(0.6)
      expect(@stat_tracker.head_to_head("30")["Atlanta United"]).to eq(atl_expected)
    end
  end
end