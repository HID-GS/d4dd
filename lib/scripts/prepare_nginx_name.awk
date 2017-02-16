{
  if ($1 == "site_name:") {
    site_name = $2;
    exit;
  }
}

END {
  print gensub("\x27", "", "g", site_name);
}
