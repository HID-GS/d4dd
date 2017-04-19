<html>
<head>
<title><?php echo $title ?></title>
<style type="text/css">
body {
  font-family: Helvetica, Arial, sans-serif;
}
h1 {
  font-size: medium;
}
th {
  text-align: left;
  padding-top: 5px;
}
.files {
  list-style: none;
}
.code {
  width: 100%;
  font-family: "Lucida Console", Monaco, monospace;
  font-size: 12px;
  border-spacing: 0;
  white-space: pre-wrap;
}
.lineNo {
  vertical-align: top;
  color: #ccc;
}
.covered {
  color: #090;
}
div.coverage {
  position: relative;
  background-color: #ddd;
  height: 1.2em;
  line-height: 1.2em;
  overflow: hidden;
  max-width: 600px;
  border-radius: 3px;
  margin-bottom: .5em;
}
  div.coverage .bar {
    background-color: #2d2;
    height: 100%;
  }

  .pct {
    position: absolute;
    left: 1em;
    top: 0;
    bottom: 0;
    height: 100%;
    z-index: 2;
  }
.missed {
  color: #f00;
}
.dead {
  color: #00f;
}
.comment {
  color: #666;
}
</style>
<script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
<script src="http://code.jquery.com/jquery-migrate-1.2.1.min.js"></script>
<script>
jQuery(function($) {
  $('th.coverage').each(function() {
     var $t = $(this),
        file = $t.data('file'),
        $c = $('#coverage-' + file),
        pct = $t.find('.percentage').text(),
        $bar = $('<div class="bar">').css('width', pct + '%');


    $c
      .append($bar)
      .append('<span class="pct">' + pct + '%</span>')
      .css('visibility', 'visible')
  });
});
</script>

</head>
<body>
<h1 id="title"><?php echo $title ?></h1>

<h2>Files:</h2>
<ul class="files">
<?php foreach (array_keys($cov) as $i => $file) {
  $file = str_replace(DRUPAL_ROOT, '', $file); ?>
<li class="file">
  <a href="#file-<?php echo $i; ?>"><?php echo $file; ?></a>
  <div class="coverage" id="coverage-<?php echo $i; ?>"></div>
</li>
<?php } ?>
</ul>

<?php
// Render HTML versions of the files
$j = 0;
foreach ($cov as $file => $cov_lines) {
  $fd = fopen($file, 'r');
  $missed = $comment = $covered = $dead = 0;
  $file = str_replace(DRUPAL_ROOT, '', $file);
?>

<h3><a name="<?php echo 'file-' . $j; ?>"></a><?php echo $file ?></h3>

<table class="code" cellpadding="0" cellspacing="0">
<tbody>
<?php 
  for ($i = 1; $line = fgets($fd); $i++) {
  if (!isset($cov_lines[$i])) {
    $coverage = 'comment';
    $comment++;
  } else if($cov_lines[$i] == -1) {
    $coverage = 'missed';
    $missed++;
  } else if($cov_lines[$i] == -2) {
    $coverage = 'dead';
    $covered++; // Count dead lines as covered
  } else {
    $coverage = 'covered';
    $covered++;
  } 
?>
  <tr>
     <td class="lineNo"><?php echo $i; ?></td>
     <td class="code <?php echo $coverage; ?>"><?php echo htmlentities($line) ?></td>
  </tr>
<?php } ?>
</tbody>
<tfoot>
  <tr>
    <th></th>
    <th class="coverage" data-file="<?php echo $j; ?>"><span class="percentage"><?php echo ((int) ($covered / ($missed + $covered) * 1000)) / 10; ?></span>% coverage</th>
  </tr>
</tfoot>
<?php
  fclose($fd);
  $j++;
?>
</table>
<?php } ?>h

<h2>Legend</h2>
<dl>
  <dt><span class="missed">Missed</span></dt>
  <dd>lines code that <strong>were not</strong> exercised during program execution.</dd>
  <dt><span class="covered">Covered</span></dt>
  <dd>lines code <strong>were</strong> exercised during program execution.</dd>
  <dt><span class="comment">Comment/non executable</span></dt>
  <dd>Comment or non-executable line of code.</dd>
  <dt><span class="dead">Dead</span></dt>
  <dd>lines of code that according to xdebug could not be executed.  This is counted as coverage code because
  in almost all cases it is code that runnable.</dd>
</dl>
</body>
</html>
