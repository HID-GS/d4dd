BEGIN {state=0;}

{
  if ($1 == "languages:" && state == 0) {
    state = 1;
  }
  else if (state == 1 && $1 == "-") {
    langs[$2] = $2;
  }
  else if (state == 1 && $1 != "-") {
    state = 2;
  }
  else if ($1 == "site_name:") {
    site_name = $2;
  }
}

END {
  site_url = site_name ".dev"
  aliases = site_url " www." site_url;
  for (lang in langs) {
    aliases = aliases " " lang "." site_url;
  }
  print gensub("\x27", "", "g", aliases);
}
