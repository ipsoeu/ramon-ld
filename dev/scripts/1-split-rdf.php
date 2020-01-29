<?php

  ini_set('display_errors',1);
  error_reporting(-1);
  set_time_limit(600);

  include("config.php");

  $base_uri = BASE_URI;
/*
  $claset  = "nuts";
  $version = "2013";
  $claset  = "nace";
  $version = "2008";

  $xsluri["nace"] = NACE_TO_SKOS;
  $xsluri["nuts"] = NUTS_TO_SKOS;

  $xmluri["nace"]["1990"]   = '../src/NACE_REV1.xml';
  $xmluri["nace"]["2002"] = '../src/NACE_1_1.xml';
  $xmluri["nace"]["2008"]   = '../src/NACE_REV2.xml';

  $xmluri["nuts"]["2010"] = '../src/NUTS_33.xml';
  $xmluri["nuts"]["2013"] = '../src/NUTS_2013.xml';
  $xmluri["nuts"]["2016"] = '../src/NUTS_2016.xml';
*/

foreach ($dataset as $k => $v) {
  foreach ($dataset[$k]["versions"] as $dv) {

  $claset = $k;
  $version = $dv;

  $src = "../../" . $claset . "/" . $version . ".rdf";
  $target_folder = "../../" . $claset . "/" . $version;

  $query = "//*[rdf:type/@rdf:resource ='http://www.w3.org/2004/02/skos/core#Concept' and skos:inScheme/@rdf:resource = '" . $base_uri . $claset . "/" . $version . "']";

  $rdf = '<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dcat="http://www.w3.org/ns/dcat#" xmlns:gsp="http://www.opengis.net/ont/geosparql#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:xkos="http://rdf-vocabulary.ddialliance.org/xkos#" xmlns:xsd="http://www.w3.org/2001/XMLSchema#" xmlns:wdrs="http://www.w3.org/2007/05/powder-s#"></rdf:RDF>';

  if (!file_exists($target_folder)) {
    mkdir($target_folder);
  }

  $xml = new DOMDocument;
  $xml->load($src);

  $xpath = new DOMXPath($xml);
  $xpath->registerNamespace('rdf', "http://www.w3.org/1999/02/22-rdf-syntax-ns#");
  $xpath->registerNamespace('skos', "http://www.w3.org/2004/02/skos/core#");

  $entries = $xpath->query($query);

  foreach ($entries as $entry) {
    $filename = str_replace($base_uri . $claset . "/" . $version . "/", "", $entry->getAttribute("rdf:about"));
    $root = new DOMDocument('1.0','utf-8');
    $root->preserveWhiteSpace = false;
    $root->formatOutput = true;
    $root->loadXML($rdf);
    $entry = $root->importNode($entry, true);
    $root->documentElement->appendChild($entry);
    $content = $root->saveXML();
    file_put_contents($target_folder . "/" . $filename . ".rdf", $content);
  }

//  header('Content-type: application/xml; charset=utf8');
//  echo $output;

  }
}

?>
