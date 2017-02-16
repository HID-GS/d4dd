{
  if ($1 == "database:") {
    database = $2;
    exit;
  }
}

END {
  print gensub("\x27", "", "g", database);
}
