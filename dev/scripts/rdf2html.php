<?php

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
  file_put_contents('../../' . $k . '/' . $version . '.html', $output);

//  header('Content-type: application/xml; charset=utf8');
//  echo $output;

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
    file_put_contents(dirname($path) . "/" . basename($path,".rdf") . '.html', $output);
  }

//  }

?>
