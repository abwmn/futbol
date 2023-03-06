module GameTeamsHelper
  def nested_hash
    Hash.new { |h, k| h[k] = Hash.new(0) }
  end

  def super_nested_hash
    Hash.new { |h, k| h[k] = Hash.new { |h, k| h[k] = Hash.new(0) } }
  end

  def tackle_counter
    tackles = nested_hash
    (0..@game_id.count).each do |i|
      tackles[@team_id[i]][@game_id[i]&.slice(0..3)] += @tackles[i].to_i
    end
    tackles
  end

  def tackle_checker(season)
    best_team, worst_team = nil, nil
    most_tackles, least_tackles = 0, 5000
    tackle_counter.each do |team, szns|
      tackles = szns[season.slice(0..3)]
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

  def goals_counter
    goals = nested_hash
    (0..@game_id.count).each do |i|
      goals[@team_id[i]][:goals] += @goals[i].to_i
      goals[@team_id[i]][:away] += @goals[i].to_i if @hoa[i] == 'away'
      goals[@team_id[i]][:home] += @goals[i].to_i if @hoa[i] == 'home'
      goals[@team_id[i]][:games] += 1
    end
    goals.delete(nil)
    goals
  end

  def win_loss_counter
    games = super_nested_hash
    (0..@game_id.count).each do |i|
      games[@team_id[i]][@game_id[i]&.slice(0..3)][:wins] += 1 if @result[i] == 'WIN'
      games[@team_id[i]][@game_id[i]&.slice(0..3)][:losses] += 1 if @result[i] == 'LOSS'
      games[@team_id[i]][@game_id[i]&.slice(0..3)][:games] += 1
    end
    games.delete(nil)
    games
  end

  def win_loss_checker(team)
    best_szn, worst_szn = nil, nil
    best_record, worst_record = 0, 1
    win_loss_counter[team].each do |szn, results|
      winpct = results[:wins].fdiv(results[:games])
      if winpct > best_record
        best_record = winpct
        best_szn = szn
      elsif winpct < worst_record
        worst_record = winpct
        worst_szn = szn
      end
    end
    {:best_szn => "#{best_szn}#{(best_szn.to_i + 1).to_s}", 
    :worst_szn => "#{worst_szn}#{(worst_szn.to_i + 1).to_s}"}
  end

  def goals_checker(team)
    most_goals, least_goals = 0, 10
    (0..@game_id.count).each do |i|
      if @team_id[i] == team 
        goals = @goals[i].to_i
        if goals > most_goals
          most_goals = goals
        elsif goals < least_goals
          least_goals = goals
        end
      end
    end
    {:most_goals => most_goals, :least_goals => least_goals}
  end

  def coach_counter
    coaches = super_nested_hash
    (0..@game_id.count).each do |i|
      coaches[@head_coach[i]][@game_id[i]&.slice(0..3)][:wins] += 1 if @result[i] == 'WIN'
      coaches[@head_coach[i]][@game_id[i]&.slice(0..3)][:games] += 1
    end
    coaches
  end

  def coach_checker(season)
    winningest_record, worst_record = 0, 1
    winningest_coach, worst_coach = nil, nil
    coach_counter.each do |coach, szns|
      record = szns[season.slice(0..3)][:wins]&.fdiv(szns[season.slice(0..3)][:games])
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

  def accucounter
    teams = super_nested_hash
    (0..@game_id.count).each do |i|
      teams[@team_id[i]][@game_id[i]&.slice(0..3)][:shots] += @shots[i].to_i
      teams[@team_id[i]][@game_id[i]&.slice(0..3)][:goals] += @goals[i].to_i
    end
    teams
  end

  def accuchecker(season)
    best_ratio, worst_ratio = 9, 0
    best_team, worst_team = nil, nil
    accucounter.each do |team, szns|
      ratio = szns[season.slice(0..3)][:shots]&.fdiv(szns[season.slice(0..3)][:goals])
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