case $1 in
  main)
    liquidctl --match hydro set logo color fixed 75a6ff
    openrgb -p $1.orp
    ;;
  game)
    liquidctl --match hydro set logo color fixed ff0000
    openrgb -p $1.orp
    ;;
  off)
    liquidctl --match hydro set logo color blackout
    openrgb -p black.orp
    ;;
  *)
    echo "Usage: $0 [main|game|off]"
    ;;
esac
