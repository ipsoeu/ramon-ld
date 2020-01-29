<?php

  ini_set('display_errors',1);
  error_reporting(-1);

  include("config.php");

  $skos = "2008";
  $skos = "2008/01.1";

  $xmluri = '../../nace/2008/' . $skos . '.rdf';
  $xmluri = '../../nace/' . $skos . '.rdf';
  $xsluri = '../xslt/rdf2html.xsl';
  $xsluri = '../xslt/skos2html.xsl';

  $wkt = '';
  $geojsonas4326 = '';
  $srs = '';
  $wkt = ''; //file_get_contents('./region/' . $skos . '.txt');
  $geojsonas4326 = ''; //file_get_contents('./region/' . $skos . '.json');
  $srs = 4258;
  
  $toolname = "Linked Data @ JRC";

  $xml = new DOMDocument;
  $xml->load($xmluri);
/*  
  if (!$xml->load($xmluri)) {
    echo "Not able to load " . $xmluri;
    exit;
  }
*/

  $xsl = new DOMDocument;
  $xsl->load($xsluri);
/*
  if (!$xsl->load($xsluri)) {
    echo "Not able to load " . $xsluri;
    exit;
  }
*/

  $proc = new XSLTProcessor();
  $proc->importStyleSheet($xsl);
  $proc->setParameter('', 'toolname', $toolname);
  $proc->setParameter('', 'wkt', $wkt);
  $proc->setParameter('', 'srs', $srs);
  $proc->setParameter('', 'geojsonas4326', $geojsonas4326);
      
  header('Content-type: text/html; charset=utf8');
  echo $proc->transformToXML($xml);
//  $output = $proc->transformToXML($xml);
//  file_put_contents('../../' . $claset . '/' . $version . '.rdf', $output);

?>
