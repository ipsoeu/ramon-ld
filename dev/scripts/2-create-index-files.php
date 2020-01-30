<?php

  ini_set('display_errors',1);
  error_reporting(-1);
  set_time_limit(600);

  include("config.php");

  $base_uri = BASE_URI;

//  $src = "../../" . $claset . "/" . $version . ".rdf";
  $target_folder = "../../";

  if (!file_exists($target_folder)) {
    mkdir($target_folder);
  }


  $ns["rdf"]  = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#';
  $ns["dcat"] = 'http://www.w3.org/ns/dcat#';
  $ns["dct"]  = 'http://purl.org/dc/terms/';
  $ns["gsp"]  = 'http://www.opengis.net/ont/geosparql#';
  $ns["rdfs"] = 'http://www.w3.org/2000/01/rdf-schema#';
  $ns["skos"] = 'http://www.w3.org/2004/02/skos/core#';
  $ns["xkos"] = 'http://rdf-vocabulary.ddialliance.org/xkos#';
  $ns["xsd"]  = 'http://www.w3.org/2001/XMLSchema#';
  $ns["wdrs"] = 'http://www.w3.org/2007/05/powder-s#';
  $ns["ft"]   = 'http://publications.europa.eu/resource/authority/file-type/';
  $ns["mt"]   = 'https://www.iana.org/assignments/media-types/';

  $namespaces = array();
  foreach ($ns as $k => $v) {
    $namespaces[] = 'xmlns:' . $k . '="' . $v . '"';
  }

  $header  = '<?xml version="1.0" encoding="utf-8"?>' . "\n";
  $header .= '<rdf:RDF ' . join(" ", $namespaces) . '>' . "\n";

  $output  = $header;
  $output .= '  <rdf:Description rdf:about="' . $base_uri . '">' . "\n";
  $output .= '    <rdf:type rdf:resource="' . $ns["dcat"] . 'Catalog"/>' . "\n";
  $output .= '    <dct:identifier>' . strtolower(TOOL_ACRONYM) . '</dct:identifier>' . "\n";
  $output .= '    <dct:alternative>' . TOOL_ACRONYM . '</dct:alternative>' . "\n";
  $output .= '    <dct:title xml:lang="en">' . TOOL_NAME . '</dct:title>' . "\n";
  $output .= '    <dct:description xml:lang="en">' . ABOUT_TEXT . '</dct:description>' . "\n";
  $output .= '    <dcat:landingPage rdf:resource="' . $base_uri . '"/>' . "\n";
/*
  foreach ($formats as $k => $v) {
    if ($k != "html") {
      $output .= '    <dcat:distribution>' . "\n";
      $output .= '      <rdf:Description>' . "\n";
      $output .= '        <rdf:type rdf:resource="' . $ns["dcat"] . 'Distribution"/>' . "\n";
      $output .= '        <dct:title xml:lang="en">' . $formats[$k]["title"] . ' of ' . TOOL_ACRONYM . '</dct:title>' . "\n";
      $output .= '        <dct:description xml:lang="en">' . $formats[$k]["description"] . ' of ' . TOOL_ACRONYM . '</dct:description>' . "\n";
      $output .= '        <dcat:mediaType rdf:resource="' . $ns["mt"] . $formats[$k]["iana"] . '"/>' . "\n";
      $output .= '        <dct:format rdf:resource="' . $ns["ft"] . $formats[$k]["mdr"] . '"/>' . "\n";
      $output .= '        <dcat:downloadURL rdf:resource="' . $base_uri . 'index.' . $k . '"/>' . "\n";
      $output .= '      </rdf:Description>' . "\n";
      $output .= '    </dcat:distribution>' . "\n";
    }
  }
*/
  foreach ($dataset as $k => $v) {
    $output .= '    <dcat:dataset rdf:resource="' . $base_uri . $k . '"/>' . "\n";
  }
  $output .= '  </rdf:Description>' . "\n";
  $output .= '</rdf:RDF>' . "\n";

  file_put_contents($target_folder . '/index.rdf', $output);

//  header('Content-type: application/xml; charset=utf8');
//  echo $output;

  foreach ($dataset as $k => $v) {
    $output  = $header;
    $output .= '  <rdf:Description rdf:about="' . $base_uri . $k . '">' . "\n";
    $output .= '    <rdf:type rdf:resource="' . $ns["dcat"] . 'Dataset"/>' . "\n";
    $output .= '    <dct:identifier>' . $k . '</dct:identifier>' . "\n";
    $output .= '    <dct:alternative>' . strtoupper($k) . '</dct:alternative>' . "\n";
    $output .= '    <dct:title xml:lang="en">' . $v["name"] . '</dct:title>' . "\n";
    $output .= '    <dct:description xml:lang="en">' . $v["name"] . '</dct:description>' . "\n";
    $output .= '    <dcat:landingPage rdf:resource="' . $base_uri . $k . '"/>' . "\n";
/*
    foreach ($formats as $fk => $fv) {
      if ($fk != "html") {
        $output .= '    <dcat:distribution>' . "\n";
        $output .= '      <rdf:Description>' . "\n";
        $output .= '        <rdf:type rdf:resource="' . $ns["dcat"] . 'Distribution"/>' . "\n";
        $output .= '        <dct:title xml:lang="en">' . $formats[$fk]["title"] . ' of ' . strtoupper($k) . '</dct:title>' . "\n";
        $output .= '        <dct:description xml:lang="en">' . $formats[$fk]["description"] . ' of the ' . $v["name"] . ' (' . strtoupper($k) . ').</dct:description>' . "\n";
        $output .= '        <dcat:mediaType rdf:resource="' . $ns["mt"] . $formats[$fk]["iana"] . '"/>' . "\n";
        $output .= '        <dct:format rdf:resource="' . $ns["ft"] . $formats[$fk]["mdr"] . '"/>' . "\n";
        $output .= '        <dcat:downloadURL rdf:resource="' . $base_uri . $k . '/index.' . $fk . '"/>' . "\n";
        $output .= '      </rdf:Description>' . "\n";
        $output .= '    </dcat:distribution>' . "\n";
      }
    }
*/    
    foreach (glob("../../" . $k . "/*.rdf") as $vv) {
      if (basename($vv) != "index.rdf") {
        $output .= '    <dct:hasVersion rdf:resource="' . $base_uri . $k . '/' . basename($vv, ".rdf") . '"/>' . "\n";
      }
    }
    $output .= '  </rdf:Description>' . "\n";
    $output .= '</rdf:RDF>' . "\n";
    
    file_put_contents($target_folder . '/' . $k . '/index.rdf', $output);

//    echo $output;

    foreach (glob("../../" . $k . "/*.rdf") as $vv) {
      if (basename($vv) != "index.rdf") {
//        $output .= '    <dct:hasVersion rdf:resource="' . $base_uri . $k . '/' . basename($vv, ".rdf") . '"/>' . "\n";
        file_put_contents($target_folder . '/' . $k . '/' . basename($vv, ".rdf") . '/index.rdf', file_get_contents($vv));
      }
    }
  }

?>
