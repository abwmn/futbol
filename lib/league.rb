require_relative 'requirements'

class League < StatReader
  attr_reader :team_id,
              :teamname
  
  def initialize(locations)
    file = locations[:teams]
    super(file)
  end

  def team_info(team)
    index = @team_id.find_index(team)
    team_info = {
      'team_id' => team,
      'franchise_id' => @franchiseid[index],
      'team_name' => @teamname[index],
      'abbreviation' => @abbreviation[index],
      'link' => @link[index]
    }
  end
end