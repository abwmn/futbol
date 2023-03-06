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

  ## Helper Method ##
  
  def index(team)
    @team_id.find_index(team)
  end
end

# Method	Description	Return Value
# seasonal_summary	
    # For each season that the team has played, a hash that has two keys (:regular_season and :postseason), that each point to a hash with the following keys: :win_percentage, :total_goals_scored, :total_goals_against, :average_goals_scored, :average_goals_against.	Hash