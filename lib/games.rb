require_relative 'requirements'

class Games < StatReader
  include Hashable
  include Callable

  def initialize(locations)
    file = locations[:games]
    super(file)
  end

  def highest_total_score
    max = 0
    szn.each_with_index do |_, s|
      total = @home_goals[s].to_i + @away_goals[s].to_i
      max = [max, total].max
    end
    max
  end
  
  def lowest_total_score
    min = 10
    (0..hero).each do |s|
      score = @home_goals[s].to_i + @away_goals[s].to_i
      min = [min, score].min
    end
    min
  end

  def average_goals_by_season
    avg_goals = nested_hash
    (0..hero).each do |s|
      season = @season[s]; goals = @home_goals[s].to_i + @away_goals[s].to_i
      avg_goals[season][:goals] += goals
      avg_goals[season][:games] += 1
    end
    avg_goals.transform_values do |season| 
      season[:goals].fdiv(season[:games]).round(2) 
    end
  end

  def percent_home_wins
    home_wins = 0
    (0..hero).each do |i|
      home_wins += 1 if @home_goals[i].to_i > @away_goals[i].to_i
    end
    home_wins.fdiv(hero).round(2)
  end

  def percent_away_wins
    away_wins = 0
    (0..hero).each do |i|
      away_wins += 1 if @home_goals[i].to_i < @away_goals[i].to_i
    end
    away_wins.fdiv(hero).round(2)
  end

  def percent_ties
    ties = 0
    (0..hero).each do |i|
      ties += 1 if @away_goals[i].to_i == @home_goals[i].to_i
    end
    ties.fdiv(hero).round(2)
  end

  def count_of_games_by_season
    season_games = Hash.new(0)
    (0..hero).each do |i|
      season = @season[i]
      season_games[season] += 1
    end
    season_games.delete(nil)
    season_games
  end

  def average_goals_per_game
    goals = 0
    (0..hero).each do |i|
      goals += @home_goals[i].to_i + @away_goals[i].to_i
    end
    goals.fdiv(hero).round(2)
  end

  def seasonal_summary(team)
    szn_sum = super_nested_hash
    (0..hero).each do |s|
      if team == @away_team_id[s] || team == @home_team_id[s]
        h, a = @home_goals[s].to_i, @away_goals[s].to_i
        szn = case @type[s]
        when 'Regular Season'
          szn_sum[@season[s]][:regular_season]
        else
          szn_sum[@season[s]][:postseason]
        end
        if team == @home_team_id[s]
          szn[:total_goals_scored] += h
          szn[:total_goals_against] += a
          szn[:wins] += 1 if h > a
        else
          szn[:total_goals_scored] += a
          szn[:total_goals_against] += h
          szn[:wins] += 1 if a > h
        end
        szn[:games] += 1
      end
    end
    season_stats(szn_sum)
  end

  def season_stats(szn_sum)
    szn_sum.each do |season, stats|
      rglr = stats[:regular_season]
      post = stats[:postseason]
      [rglr, post].each do |szn|
        szn[:win_percentage] = szn[:wins].fdiv(szn[:games]).round(3)
        szn[:average_goals_against] = szn[:total_goals_against].fdiv(szn[:games]).round(2)
        szn[:average_goals_scored] = szn[:total_goals_scored].fdiv(szn[:games]).round(2)
      end
    end
    szn_sum
  end
end