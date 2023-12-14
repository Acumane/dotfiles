find . -type f -name "*.spotdl" | while read path
do
  dir=$(dirname "$path")
  file=$(basename "$path")
  cd "$dir" || exit
  spotdl sync "$file" --preload --thread 8 --scan-for-songs --overwrite skip --dont-filter-results 
  cd .. || exit
done
