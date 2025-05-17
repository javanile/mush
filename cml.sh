#!/usr/bin/env bash

# Estrae lo score da @score: X
get_score() {
  local file="$1"
  local line
  line=$(grep -m1 -E '@score: *([0-9]+(\.[0-9]+)?)' "$file")
  if [[ $line =~ ([0-9]+(\.[0-9]+)?) ]]; then
    echo "${BASH_REMATCH[1]}"
  else
    echo ""
  fi
}

if [[ $# -eq 0 ]]; then
  echo "Usage: $0 path1 [path2 ...]"
  exit 1
fi

# Trova tutti i file
mapfile -t files < <(find "$@" -type f)

N=${#files[@]}
if (( N == 0 )); then
  echo "No files found."
  exit 1
fi

# Analizza tutti i file
declare -a scores
declare -a paths
declare -a mtimes
sum=0
file_missing_score=""
oldest_mtime=9999999999
min_score_file=""
min_score=9999

for f in "${files[@]}"; do
  score=$(get_score "$f")
  mtime=$(stat -c "%Y" "$f")  # Epoch time

  paths+=("$f")
  mtimes+=("$mtime")

  if [[ -z $score ]]; then
    score_val=0
  else
    score_val=$score
  fi

  scores+=("$score_val")
  sum=$(awk -v a="$sum" -v b="$score_val" 'BEGIN{print a + b}')

  # Trova file più vecchio non ancora valutato
  if [[ -z $score && $mtime -lt $oldest_mtime ]]; then
    oldest_mtime=$mtime
    file_missing_score="$f"
  fi

  # Trova file con punteggio minimo (anche 0)
  if awk -v s="$score_val" -v min="$min_score" 'BEGIN{exit !(s < min)}'; then
    min_score=$score_val
    min_score_file="$f"
  fi
done

# Calcola media
mean=$(awk -v s="$sum" -v n="$N" 'BEGIN{if(n==0) print 0; else printf "%.6f", s/n}')

# Conta quanti sopra la media
above=0
for s in "${scores[@]}"; do
  awk -v val="$s" -v mu="$mean" 'BEGIN{if(val >= mu) exit 0; exit 1}' && ((above++))
done
p=$(awk -v a="$above" -v n="$N" 'BEGIN{printf "%.6f", a/n}')

# Deviazione standard
sum_sq=0
for s in "${scores[@]}"; do
  diff=$(awk -v val="$s" -v mu="$mean" 'BEGIN{print val - mu}')
  sq=$(awk -v d="$diff" 'BEGIN{print d*d}')
  sum_sq=$(awk -v sum="$sum_sq" -v sq="$sq" 'BEGIN{print sum + sq}')
done
sigma=$(awk -v sum_sq="$sum_sq" -v n="$N" 'BEGIN{printf "%.6f", sqrt(sum_sq/n)}')

# Varianza normalizzata
var_norm=$(awk -v sigma="$sigma" -v mean="$mean" 'BEGIN{
  if (mean == 0) print 0;
  else {
    v = 1 - (sigma / mean);
    if (v < 0) v = 0;
    printf "%.6f", v;
  }
}')

# CML
CML=$(awk -v p="$p" -v v="$var_norm" 'BEGIN{printf "%.6f", p * v}')

# Output CML
echo "Files analyzed: $N"
echo "Mean score: $mean"
echo "Standard deviation: $sigma"
echo "Files >= mean: $above / $N"
echo "Percentage above mean: $(awk -v p="$p" 'BEGIN{printf "%.2f%%", p*100}')"
echo "Normalized variance: $var_norm"
echo "CML Score: $(awk -v cml="$CML" 'BEGIN{printf "%.2f%%", cml*100}')"
echo

# Suggerimento per azione
if [[ -n $file_missing_score ]]; then
  echo "➡️  Next file to score (oldest without score): $file_missing_score"
else
  echo "⚠️  All files have scores. Lowest scored file: $min_score_file (score: $min_score)"
fi
