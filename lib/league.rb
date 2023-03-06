require_relative 'requirements'

class League < StatBook
  attr_reader :team_id,
              :teamname
  
  def initialize(locations)
    file = locations[:teams]
    super(file)
  end

  def count_of_teams
    @team_id.count
  end

  def team_info(team)
    index = index(team)
    team_info = {
      'team_id' => team,
      'franchise_id' => @franchiseid[index],
      'team_name' => @teamname[index],
      'abbreviation' => @abbreviation[index],
      'link' => @link[index]
    }
  end

  def favorite_opponent(team)

  end

  def rival(team)

  end

  def biggest_team_blowout(team)

  end

  def worst_loss(team)

  end

  def head_to_head(team)

  end

  def seasonal_summary(team)

  end

  ## Helper Method ##
  
  def index(team)
    @team_id.find_index(team)
  end
end


# Method	Description	Return Value

# favorite_opponent	
    # Name of the opponent that has the lowest win percentage against the given team.	String
# rival	
    # Name of the opponent that has the highest win percentage against the given team.	String
# biggest_team_blowout	
    # Biggest difference between team goals and opponent goals for a win for the given team.	Integer
# worst_loss	
    # Biggest difference between team goals and opponent goals for a loss for the given team.	Integer
# head_to_head	
    # Record (as a hash - win/loss) against all opponents with the opponents’ names as keys and the win percentage against that opponent as a value.	Hash
# seasonal_summary	
    # For each season that the team has played, a hash that has two keys (:regular_season and :postseason), that each point to a hash with the following keys: :win_percentage, :total_goals_scored, :total_goals_against, :average_goals_scored, :average_goals_against.	Hash