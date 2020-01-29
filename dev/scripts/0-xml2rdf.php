<?php

  ini_set('display_errors',1);
  error_reporting(-1);
  set_time_limit(600);

  include("config.php");

  $base_uri = BASE_URI;

//  $src = "../../" . $claset . "/" . $version . ".rdf";
  $target_folder = "../../" . $claset;

  if (!file_exists($target_folder)) {
    mkdir($target_folder);
  }

  $xml = new DOMDocument;
  $xml = new DOMDocument;
  $xml->load($xmluri[$claset][$version]["xml"]);

  $xsl = new DOMDocument;
  $xsl->load($xsluri[$claset]["xml2rdf"]);

  $proc = new XSLTProcessor();
  $proc->importStyleSheet($xsl);
  $proc->setParameter('', 'classification-uri', $base_uri . $claset . '/');
  foreach ($formats as $k => $n) {
    $proc->setParameter('', $formats[$k]["code"], "yes");
  }
 
  $output = $proc->transformToXML($xml);
  file_put_contents($target_folder . '/' . $version . '.rdf', $output);

//  header('Content-type: application/xml; charset=utf8');
//  echo $output;

?>
