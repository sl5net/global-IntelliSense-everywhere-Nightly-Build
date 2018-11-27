SELECT word, worddescription, wordreplacement
     FROM Words
     WHERE wordindexed GLOB upper('s') || '*'
     and   ActionListID > 0
     order by ROWID desc
     LIMIT 9
