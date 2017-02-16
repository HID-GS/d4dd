$0 ~ /^site_root_local/ || $0 ~ /^site_name/ {
  if ($1 == "site_name:") {
    sitename = $2;
  }
  else {
    result = gensub("~",ENVIRON["HOME"],"g", $2) ":/var/www/" sitename;
    result = gensub("'", "", "g", result)
    print "      - " result
  }
}
END {
    print "      - " ENVIRON["PWD"] ":/docker_config";
}
