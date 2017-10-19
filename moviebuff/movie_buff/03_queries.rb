def what_was_that_one_with(those_actors)
  # Find the movies starring all `those_actors` (an array of actor names).
  # Show each movie's title and id.
  num = those_actors.count
  Movie
    .select(:title, :id)
    .joins(:actors)
    .where('actors.name IN (?)', those_actors)
    .group(:id)
    .having('COUNT(*) >= (?)', num)
end

def golden_age
  # Find the decade with the highest average movie score.
  Movie
    .select('AVG(score), ((yr / 10) * 10) AS decade')
    .group('decade')
    .order('AVG(score) desc')
    .first
    .decade



end

def costars(name)
  # List the names of the actors that the named actor has ever
  # appeared with.
  # Hint: use a subquery
  subquery = Movie
  .joins(:actors)
  .where('actors.name = (?)', name)
  .pluck(:id)

  Actor
    .joins(:movies)
    .where('movies.id IN (?) AND actors.name != (?)', subquery, name)
    .distinct
    .pluck(:name)


end

def actor_out_of_work
  # Find the number of actors in the database who have not appeared in a movie
  subquery = Casting.pluck(:actor_id)
  
  Actor
    .select('COUNT(*)')
    .where('id NOT IN (?)', subquery)
end

def starring(whazzername)
  # Find the movies with an actor who had a name like `whazzername`.
  # A name is like whazzername if the actor's name contains all of the
  # letters in whazzername, ignoring case, in order.

  # ex. "Sylvester Stallone" is like "sylvester" and "lester stone" but
  # not like "stallone sylvester" or "zylvester ztallone"
  # matcher = "%#{whazzername.split(//).join('%')}%"
  # Movie.joins(:actors).where('UPPER(actors.name) LIKE UPPER(?)', matcher)

  sorted = whazzername.upcase.chars.sort.join("%")

  Movie
    .select(:title)
    .joins(:actors)
    .where("actors.name LIKE '%(?)%'", sorted)
end

def longest_career
  # Find the 3 actors who had the longest careers
  # (the greatest time between first and last movie).
  # Order by actor names. Show each actor's id, name, and the length of
  # their career.

  #find the difference of yrs starting, yrs ending

  Actor
    .select(:id, :name, '(MAX(movies.yr) - MIN(movies.yr)) AS career')
    .joins(:movies)
    .group(:id)
    .order('career DESC, name ASC')
    .limit(3)


end
