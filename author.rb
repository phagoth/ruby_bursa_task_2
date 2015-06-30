class Author
  attr_accessor :year_of_birth, :year_of_death, :name

  def initialize year_of_birth, year_of_death, name
    @year_of_birth = year_of_birth
    @year_of_death = year_of_death
    @name = name
  end

  def can_meet? other_author
    puts other_author
    lifeOfFirst = (year_of_birth..year_of_death)
    lifeOfSecond = (other_author.year_of_birth..other_author.year_of_death)
    return (lifeOfFirst.member?(other_author.year_of_birth) or lifeOfFirst.member?(other_author.year_of_death) or lifeOfSecond.member?(year_of_birth) or lifeOfSecond.member?(year_of_death))
  end
end
