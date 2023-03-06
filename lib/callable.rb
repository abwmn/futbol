module Callable
  def team
    @team_id
  end

  def szn
    @game_id
  end

  def sliced(str)
    str.slice(0..3)
  end

  def hero
    @game_id.count - 1
  end
end