<?php

  ini_set('display_errors',1);
  error_reporting(-1);
  set_time_limit(600);

  include("config.php");

  $base_uri = BASE_URI;

//var_dump(rglob("../../*.rdf"));

foreach (rglob(ROOT . "*.rdf") as $file) {
  $claset = "";
  $version = "";
//  echo dirname($file)."/".basename($file,".rdf").".html" . "\n";
//  echo basename(dirname($file))."\n";
//  $p = explode("/",substr($file, strlen(ROOT)));
  $p = explode("/",substr(dirname($file)."/".basename($file,".rdf"), strlen(ROOT)));
//  var_dump($p);
  if (count($p) > 0) {
    if (isset($dataset[$p[0]])) {
      $claset = $p[0];
//      var_dump($claset);
      if (isset($p[1]) && is_dir(ROOT . $p[0] . "/" . $p[1])) {
        $version = $p[1];
//        var_dump($version);
      }
    }
  }
  
  $xmluri = $file;
//  $uri = end(explode(dirname($file),$abs_path))."/".basename($file,".rdf");
//  $uri = rtrim($base_uri.substr(dirname($file),strlen(ROOT)-1),"/")."/".basename($file,".rdf");
//  $uri = rtrim(rtrim($base_uri.substr(dirname($file),strlen(ROOT)),"/")."/".basename($file,".rdf"),"/index");
  $uri = $base_uri.trim(rtrim(rtrim(substr(dirname($file),strlen(ROOT))."/".basename($file,".rdf"),"/"),"/index"),"/");
//  echo dirname($file) . "\n";
//  echo $file . "\n";
  echo $uri . "\n";
  $targetfile = dirname($file)."/".basename($file,".rdf").".html";

  $xml = new DOMDocument;
  $xml = new DOMDocument;
  $xml->load($xmluri);

  $xsl = new DOMDocument;
  $xsl->load($xsluri["rdf2html"]);

  $proc = new XSLTProcessor();
  $proc->importStyleSheet($xsl);
  $proc->setParameter('', 'abs_path', ABS_PATH);
  $proc->setParameter('', 'root', ROOT);
  $proc->setParameter('', 'toolacronym', TOOL_ACRONYM);
  $proc->setParameter('', 'toolname', TOOL_NAME);
  $proc->setParameter('', 'aboutUrl', ABOUT_URL);
  $proc->setParameter('', 'aboutText', ABOUT_TEXT);
  $proc->setParameter('', 'licenceUrl', LICENCE_URL);
  $proc->setParameter('', 'licenceName', LICENCE_NAME);
  $proc->setParameter('', 'uri', $uri);
  $proc->setParameter('', 'base_uri', $base_uri);
  $proc->setParameter('', 'name', strtoupper($claset));
  $proc->setParameter('', 'code', $claset);
  $proc->setParameter('', 'version', $version);
 
  $output = $proc->transformToXML($xml);
  file_put_contents($targetfile, $output);

}

function rglob($pattern, $flags = 0) {
  $files = glob($pattern, $flags); 
  foreach (glob(dirname($pattern).'/*', GLOB_ONLYDIR|GLOB_NOSORT) as $dir) {
    $files = array_merge($files, rglob($dir.'/'.basename($pattern), $flags));
  }
  return $files;
}

/*

  ini_set('display_errors',1);
  error_reporting(-1);
  set_time_limit(600);

  include("config.php");

  $base_uri = BASE_URI;

  $k = $claset;
//  foreach ($dataset as $k => $v) {

  $xml = new DOMDocument;
  $xml = new DOMDocument;
  $xml->load($xmluri[$k][$version]["rdf"]);

  $xsl = new DOMDocument;
  $xsl->load($xsluri[$k]["rdf2html"]);

  $proc = new XSLTProcessor();
  $proc->importStyleSheet($xsl);
  $proc->setParameter('', 'toolacronym', TOOL_ACRONYM);
  $proc->setParameter('', 'toolname', TOOL_NAME);
  $proc->setParameter('', 'aboutUrl', ABOUT_URL);
  $proc->setParameter('', 'aboutText', ABOUT_TEXT);
  $proc->setParameter('', 'base_uri', $base_uri);
  $proc->setParameter('', 'name', strtoupper($k));
  $proc->setParameter('', 'code', $k);
  $proc->setParameter('', 'version', $version);
 
  $output = $proc->transformToXML($xml);

  foreach(glob('../../' . $k . '/' . $version . '/*.rdf') as $path) {
    $xml = new DOMDocument;
    $xml->load($path);

    $xsl = new DOMDocument;
    $xsl->load($xsluri[$k]["rdf2html"]);

    $proc = new XSLTProcessor();
    $proc->importStyleSheet($xsl);
    $proc->setParameter('', 'toolacronym', TOOL_ACRONYM);
    $proc->setParameter('', 'toolname', TOOL_NAME);
    $proc->setParameter('', 'aboutUrl', ABOUT_URL);
    $proc->setParameter('', 'aboutText', ABOUT_TEXT);
    $proc->setParameter('', 'base_uri', $base_uri);
    $proc->setParameter('', 'name', strtoupper($k));
    $proc->setParameter('', 'code', $k);
    $proc->setParameter('', 'version', $version);
 
    $output = $proc->transformToXML($xml);
  }

*/

?>
