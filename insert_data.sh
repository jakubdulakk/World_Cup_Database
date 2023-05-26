#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS=',' read -r year round winner opponent winner_goals opponent_goals; do
  if [[ $round != "round" ]]; then  # Skip the header row
    $PSQL "INSERT INTO teams (name) VALUES ('$winner');"
    $PSQL "INSERT INTO teams (name) VALUES ('$opponent');"
  fi
done

cat games.csv | while IFS=',' read -r year round winner opponent winner_goals opponent_goals; do
  if [[ $round != "round" ]]; then  # Skip the header row
    winner_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$winner';")
    opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$opponent';")

    $PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ('$year', '$round', '$winner_id', '$opponent_id', '$winner_goals', '$opponent_goals');"
  fi
done

