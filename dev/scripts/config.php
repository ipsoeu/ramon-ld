<?php

  define("ABS_PATH","/ramon-ld/");
  define("ROOT","../../");
//  define("BASE_URI","http://localhost/ramon-ld/");
//  define("BASE_URI","https://ipsoeu.github.io/ramon-ld/");
  define("BASE_URI","https://w3id.org/ipsoeu/ramon-ld/");
  define("TOOL_ACRONYM","RAMON-LD");
  define("TOOL_NAME","RAMON as Linked Data");
  define("ABOUT_URL","https://github.com/ipsoeu/ramon-ld");
  define("ABOUT_TEXT","RAMON-LD is an experimental Linked Data implementation of the EUROSTAT RAMON registry.");
  define("PUBLISHER_NAME","European Commission");
  define("PUBLISHER_URL","http://publications.europa.eu/resource/authority/corporate-body/COM");
  define("LICENCE_NAME","CC-BY 4.0");
  define("LICENCE_URL","http://creativecommons.org/licenses/by/4.0/");
  define("RAMON_TO_RDF","../xslt/ramon-to-rdf.xsl");
  define("NACE_TO_SKOS","../xslt/nace-to-skos.xsl");
  define("SKOS_TO_HTML","../xslt/skos2html.xsl");

//  $abs_path = parse_url(BASE_URI, PHP_URL_PATH);

  $formats["html"]["code"] = "format_html";
  $formats["html"]["label"] = "HTML";
  $formats["html"]["mdr"] = "HTML";
  $formats["html"]["iana"] = "text/html";

  $formats["rdf"]["code"] = "format_rdf";
  $formats["rdf"]["label"] = "RDF/XML";
  $formats["rdf"]["mdr"] = "RDF_XML";
  $formats["rdf"]["iana"] = "application/rdf+xml";
  
//  formats["ttl"]["code"] = "format_ttl";
//  formats["ttl"]["label"] = "Turtle";
//  formats["ttl"]["mdr"] = "RDF_TURTLE";
//  formats["ttl"]["iana"] = "text/turtle";

//  formats["jsonld"]["code"] = "format_jsonld";
//  formats["jsonld"]["label"] = "JSON-LD";
//  formats["jsonld"]["mdr"] = "JSON_LD";
//  formats["jsonld"]["iana"] = "application/ld+json";

//  formats["nt"]["code"] = "format_nt";
//  formats["nt"]["label"] = "N-Triples";
//  formats["nt"]["mdr"] = "RDF_N_TRIPLES";
//  formats["nt"]["iana"] = "application/n-triples";

//  formats["n3"]["code"] = "format_n3";
//  formats["n3"]["label"] = "N3";
//  formats["n3"]["mdr"] = "N3";
//  formats["n3"]["iana"] = "text/n3";

//  formats[""]["code"] = "";
//  formats[""]["label"] = "";
//  formats[""]["mdr"] = "";
//  formats[""]["iana"] = "";

  foreach ($formats as $k => $v) {
    $formats[$k]["title"] = $formats[$k]["label"] . " representation";
    $formats[$k]["description"] = $formats[$k]["label"] . " representation";
  }

  $claset  = "cofog";
  $version = "1999";
  $claset  = "cpa";
  $version = "2014";
  $claset  = "nace";
  $version = "1990";
  $claset  = "nace";
  $version = "2002";
  $claset  = "nace";
  $version = "2008";
  $claset  = "nuts";
  $version = "2010";
  $claset  = "nuts";
  $version = "2013";
  $claset  = "nuts";
  $version = "2016";
  $claset  = "nuts";
  $version = "2021";

  $dataset["cofog"]["id"] = "cofog";
  $dataset["cofog"]["name"] = "Classification of the functions of government";
  $dataset["cofog"]["versions"] = array("1999");

  $dataset["cpa"]["id"] = "cpa";
  $dataset["cpa"]["name"] = "Statistical Classification of Products by Activity in the European Union";
  $dataset["cpa"]["versions"] = array("2014");

  $dataset["nace"]["id"] = "nace";
  $dataset["nace"]["name"] = "Statistical Classification of Economic Activities in the European Community";
  $dataset["nace"]["versions"] = array("1990", "2002", "2008");

  $dataset["nuts"]["id"] = "nuts";
  $dataset["nuts"]["name"] = "Nomenclature of Territorial Units for Statistics";
  $dataset["nuts"]["versions"] = array("2010", "2013", "2016", "2021");


  $xsluri["cofog"]["xml2rdf"] = RAMON_TO_RDF;
  $xsluri["cpa"]["xml2rdf"] = NACE_TO_SKOS;
  $xsluri["nace"]["xml2rdf"] = NACE_TO_SKOS;
  $xsluri["nuts"]["xml2rdf"] = RAMON_TO_RDF;

  $xsluri["rdf2html"] = SKOS_TO_HTML;
//  $xsluri["cpa"]["rdf2html"] = SKOS_TO_HTML;
//  $xsluri["cofog"]["rdf2html"] = SKOS_TO_HTML;
//  $xsluri["nace"]["rdf2html"] = SKOS_TO_HTML;
//  $xsluri["nuts"]["rdf2html"] = SKOS_TO_HTML;

  $xmluri["cofog"]["1999"]["xml"] = '../src/CL_COFOG99.xml';

  $xmluri["cpa"]["2014"]["xml"] = '../src/CPA_2_1.xml';

  $xmluri["nace"]["1990"]["xml"] = '../src/NACE_REV1.xml';
  $xmluri["nace"]["2002"]["xml"] = '../src/NACE_1_1.xml';
  $xmluri["nace"]["2008"]["xml"] = '../src/NACE_REV2.xml';

  $xmluri["nuts"]["2010"]["xml"] = '../src/NUTS_33.xml';
  $xmluri["nuts"]["2013"]["xml"] = '../src/NUTS_2013.xml';
  $xmluri["nuts"]["2016"]["xml"] = '../src/NUTS_2016.xml';
  $xmluri["nuts"]["2021"]["xml"] = '../src/NUTS_2021.xml';

  $xmluri["cofog"]["1999"]["rdf"] = '../../cofog/1999.rdf';

  $xmluri["cpa"]["2014"]["rdf"] = '../../cpa/2014.rdf';

  $xmluri["nace"]["1990"]["rdf"] = '../../nace/1990.rdf';
  $xmluri["nace"]["2002"]["rdf"] = '../../nace/2002.rdf';
  $xmluri["nace"]["2008"]["rdf"] = '../../nace/2008.rdf';

  $xmluri["nuts"]["2010"]["rdf"] = '../../nuts/2010.rdf';
  $xmluri["nuts"]["2013"]["rdf"] = '../../nuts/2013.rdf';
  $xmluri["nuts"]["2016"]["rdf"] = '../../nuts/2016.rdf';
  $xmluri["nuts"]["2021"]["rdf"] = '../../nuts/2021.rdf';

?>
