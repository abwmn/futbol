require_relative 'hashable'
require_relative 'callable'

module GameTeamsHelper
  include Hashable
  include Callable

  def goals_counter
    goals = nested_hash
    (0..hero).each do |s|
      goals[team[s]][:goals] += @goals[s].to_i
      goals[team[s]][:away] += @goals[s].to_i if @hoa[s] == 'away'
      goals[team[s]][:home] += @goals[s].to_i if @hoa[s] == 'home'
      goals[team[s]][:games] += 1
    end
    goals
  end

  def goals_checker(teem)
    most_goals, least_goals = 0, 10
    (0..hero).each do |o|
      if team[o] == teem 
        goals = @goals[o].to_i
        if goals > most_goals
          most_goals = goals
        elsif goals < least_goals
          least_goals = goals
        end
      end
    end
    {:most_goals => most_goals, :least_goals => least_goals}
  end

  def win_loss_counter
    games = super_nested_hash
    (0..hero).each do |s|
      games[team[s]][sliced(szn[s])][:wins] += 1 if @result[s] == 'WIN'
      games[team[s]][sliced(szn[s])][:losses] += 1 if @result[s] == 'LOSS'
      games[team[s]][sliced(szn[s])][:games] += 1
    end
    games
  end

  def win_loss_checker(team)
    best_szn, worst_szn = nil, nil
    best_record, worst_record = 0, 1
    win_loss_counter[team].each do |szn, results|
      win_pct = results[:wins].fdiv(results[:games])
      if win_pct > best_record
        best_record = win_pct 
        best_szn = szn
      elsif win_pct < worst_record
        worst_record = win_pct
        worst_szn = szn
      end
    end
    {:best_szn => "#{best_szn}#{(best_szn.to_i + 1).to_s}", 
    :worst_szn => "#{worst_szn}#{(worst_szn.to_i + 1).to_s}"}
  end

  def coach_counter
    coaches = super_nested_hash
    (0..hero).each do |x|
      coaches[@head_coach[x]][sliced(szn[x])][:wins] += 1 if @result[x] == 'WIN'
      coaches[@head_coach[x]][sliced(szn[x])][:games] += 1
    end
    coaches
  end

  def coach_checker(season)
    winningest_record, worst_record = 0, 1
    winningest_coach, worst_coach = nil, nil
    coach_counter.each do |coach, szns|
      record = szns[sliced(season)][:wins].fdiv(szns[sliced(season)][:games])
      if record > winningest_record
        winningest_record = record
        winningest_coach = coach
      elsif record < worst_record
        worst_record = record
        worst_coach = coach
      end
    end
    {:best_coach => winningest_coach, :worst_coach => worst_coach}
  end

  def tackle_counter
    tackles = nested_hash
    (0..hero).each do |s|
      tackles[team[s]][sliced(szn[s])] += @tackles[s].to_i
    end
    tackles
  end

  def tackle_checker(season)
    best_team, worst_team = nil, nil
    most_tackles, least_tackles = 0, 5000
    tackle_counter.each do |team, szns|
      tackles = szns[sliced(season)]
      if least_tackles > tackles && tackles > 0
        least_tackles = tackles
        worst_team = team
      elsif most_tackles < tackles
        most_tackles = tackles
        best_team = team
      end
    end
    {:best_team => best_team, :worst_team => worst_team}
  end

  def accucounter
    teams = super_nested_hash
    (0..hero).each do |y|
      teams[team[y]][sliced(szn[y])][:shots] += @shots[y].to_i
      teams[team[y]][sliced(szn[y])][:goals] += @goals[y].to_i
    end
    teams
  end

  def accuchecker(season)
    best_ratio, worst_ratio = 9, 0
    best_team, worst_team = nil, nil
    accucounter.each do |team, szns|
      ratio = szns[sliced(season)][:shots].fdiv(szns[sliced(season)][:goals])
      if ratio > worst_ratio
        worst_ratio = ratio
        worst_team = team
      elsif ratio < best_ratio
        best_ratio = ratio
        best_team = team
      end
    end
    {:best_team => best_team, :worst_team => worst_team}
  end
end