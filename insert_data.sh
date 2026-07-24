#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi
$PSQL "TRUNCATE teams, games"
# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
    DATA_WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    DATA_OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ -z $DATA_WINNER_ID ]]
    then
      $PSQL "INSERT INTO teams(name) VALUES('$WINNER')"
      DATA_WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi
    if [[ -z $DATA_OPPONENT_ID ]]
    then
      $PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')"
      DATA_OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi
    $PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $DATA_WINNER_ID, $DATA_OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)"
  fi
done
