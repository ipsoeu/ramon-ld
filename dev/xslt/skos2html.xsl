<?xml version="1.0" encoding="utf-8" ?>
<!--  

  Copyright 2015-2020 EUROPEAN UNION
  Licensed under the EUPL, Version 1.1 or - as soon they will be approved by
  the European Commission - subsequent versions of the EUPL (the "Licence");
  You may not use this work except in compliance with the Licence.
  You may obtain a copy of the Licence at:
 
  http://ec.europa.eu/idabc/eupl
 
  Unless required by applicable law or agreed to in writing, software
  distributed under the Licence is distributed on an "AS IS" basis,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the Licence for the specific language governing permissions and
  limitations under the Licence.
 
  Authors: European Commission, Joint Research Centre (JRC)
           Andrea Perego <andrea.perego@ec.europa.eu>
 
  This work was supported by the EU Interoperability Solutions for
  European Public Administrations Programme (http://ec.europa.eu/isa)
  through Action 1.17: Re-usable INSPIRE Reference Platform 
  (http://ec.europa.eu/isa/actions/01-trusted-information-exchange/1-17action_en.htm).

-->

<xsl:transform
    xmlns:cc      = "http://creativecommons.org/ns#"
    xmlns:dcat    = "http://www.w3.org/ns/dcat#"
    xmlns:dcterms = "http://purl.org/dc/terms/"
    xmlns:foaf    = "http://xmlns.com/foaf/0.1/"
    xmlns:geo     = "http://www.w3.org/2003/01/geo/wgs84_pos#"
    xmlns:locn    = "http://www.w3.org/ns/locn#"
    xmlns:owl     = "http://www.w3.org/2002/07/owl#"
    xmlns:rdf     = "http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs    = "http://www.w3.org/2000/01/rdf-schema#"
    xmlns:rec     = "http://www.w3.org/2001/02pd/rec54#"
    xmlns:schema  = "http://schema.org/"
    xmlns:sioc    = "http://rdfs.org/sioc/ns#"
    xmlns:skos    = "http://www.w3.org/2004/02/skos/core#"
    xmlns:vann    = "http://purl.org/vocab/vann/"
    xmlns:voaf    = "http://purl.org/vocommons/voaf#"
    xmlns:vs      = "http://www.w3.org/2003/06/sw-vocab-status/ns#"
    xmlns:wdrs    = "http://www.w3.org/2007/05/powder-s#"
    xmlns:xkos    = "http://rdf-vocabulary.ddialliance.org/xkos#"
    xmlns:xsl     = "http://www.w3.org/1999/XSL/Transform"
    version="1.0">

  <xsl:output method="html"
              doctype-system="about:legacy-compact"
              media-type="text/html"
              omit-xml-declaration="yes"
              encoding="UTF-8"
              indent="yes"
              exclude-result-prefixes = "rec xsl rdf rdfs owl dcterms foaf schema cc dcat wdrs sioc vs vann voaf locn" />

<!-- Parameter for the code of the language used. -->

  <xsl:param name="l">
    <xsl:text>en</xsl:text>
  </xsl:param>

  <xsl:param name="uri"/>
  <xsl:param name="base_uri">/</xsl:param>

<!-- Parameters passed to the XSLT by GeoIRI. -->

  <xsl:param name="abs_path"/>
  <xsl:param name="root"/>
  <xsl:param name="reg-code"/>
  <xsl:param name="reg-name"/>
  <xsl:param name="toolacronym"/>
  <xsl:param name="toolname"/>
  <xsl:param name="aboutUrl"/>
  <xsl:param name="aboutText"/>
  <xsl:param name="licenceUrl"/>
  <xsl:param name="licenceName"/>
  <xsl:param name="wkt"/>
  <xsl:param name="srs"/>
  <xsl:param name="code"/>
  <xsl:param name="name"/>
  <xsl:param name="version"/>
  <xsl:param name="geojsonas4326"/>
  <xsl:param name="geojsonassmp"/>

<!-- Main template -->

  <xsl:template match="/">

  <xsl:param name="resource-type">
    <xsl:choose>
      <xsl:when test="rdf:RDF/*[rdf:type/@rdf:resource = 'http://www.w3.org/ns/dcat#Catalog']">
        <xsl:text>catalogue</xsl:text>
      </xsl:when>
      <xsl:when test="rdf:RDF/*[rdf:type/@rdf:resource = 'http://www.w3.org/ns/dcat#Dataset']">
        <xsl:text>dataset</xsl:text>
      </xsl:when>
      <xsl:when test="rdf:RDF/*[rdf:type/@rdf:resource = 'http://www.w3.org/2004/02/skos/core#ConceptScheme']">
        <xsl:text>dataset</xsl:text>
      </xsl:when>
      <xsl:when test="rdf:RDF/*[rdf:type/@rdf:resource = 'http://www.w3.org/2004/02/skos/core#Concept']">
        <xsl:text>dataset-item</xsl:text>
      </xsl:when>
      <xsl:when test="rdf:RDF/*[rdf:type/@rdf:resource = 'http://www.w3.org/ns/locn#Geometry']">
        <xsl:text>geometry</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:param>

    <xsl:param name="id" select="rdf:RDF/*/dcterms:identifier|rdf:RDF/*/skos:notation"/>
    <xsl:param name="title" select="rdf:RDF/*/rdfs:label|rdf:RDF/*/dcterms:title|rdf:RDF/*/skos:prefLabel"/>
    <xsl:param name="description" select="rdf:RDF/*/rdfs:comment|rdf:RDF/*/dcterms:description|rdf:RDF/*/skos:definition"/>
    <xsl:param name="core-content-note" select="rdf:RDF/*/xkos:coreContentNote"/>
    <xsl:param name="exclusion-note" select="rdf:RDF/*/xkos:exclusionNote"/>
    <xsl:param name="alternate">
      <xsl:for-each select="rdf:RDF/rdf:Description[dcterms:format]">
        <xsl:variable name="format" select="substring-after(normalize-space(dcterms:format/@rdf:resource),'http://www.iana.org/assignments/media-types/')"/>
        <xsl:if test="$format != 'text/html'">
          <link rel="alternate" title="{rdfs:label}" href="{@rdf:about}" type="{$format}" />
        </xsl:if>
      </xsl:for-each>
      <link rel="alternate" title="RDF/XML" href="{$uri}.rdf" type="application/rdf+xml" />
    </xsl:param>
    <xsl:param name="formatList">
      <xsl:for-each select="rdf:RDF/rdf:Description[dcterms:format]">
        <xsl:variable name="format" select="substring-after(normalize-space(dcterms:format/@rdf:resource),'http://www.iana.org/assignments/media-types/')"/>
        <xsl:if test="$format != 'text/html'">
          <a href="{@rdf:about}" title="{rdfs:comment}"><xsl:value-of select="rdfs:label"/></a>
        </xsl:if>
      </xsl:for-each>
      <a title="RDF/XML" href="{$uri}.rdf">RDF/XML</a>
    </xsl:param>
    <xsl:param name="formatListRDF">
      <xsl:for-each select="rdf:RDF/rdf:Description[dcterms:format]">
        <xsl:variable name="format" select="substring-after(normalize-space(dcterms:format/@rdf:resource),'http://www.iana.org/assignments/media-types/')"/>
        <xsl:if test="$format = 'application/rdf+xml' or $format = 'application/n-triples' or $format = 'text/turtle' or $format = 'text/n3' or $format = 'application/ld+json'">
          <xsl:if test="$format != 'text/html'">
            <a href="{@rdf:about}" title="{rdfs:comment}"><xsl:value-of select="rdfs:label"/></a>
          </xsl:if>
        </xsl:if>
      </xsl:for-each>
      <a title="RDF/XML" href="{$uri}.rdf">RDF/XML</a>
    </xsl:param>
    <xsl:param name="formatListOthers">
      <xsl:for-each select="rdf:RDF/rdf:Description[dcterms:format]">
        <xsl:variable name="format" select="substring-after(normalize-space(dcterms:format/@rdf:resource),'http://www.iana.org/assignments/media-types/')"/>
        <xsl:if test="not($format = 'application/rdf+xml' or $format = 'application/n-triples' or $format = 'text/turtle' or $format = 'text/n3' or $format = 'application/ld+json')">
          <xsl:if test="$format != 'text/html'">
            <a href="{@rdf:about}" title="{rdfs:comment}"><xsl:value-of select="rdfs:label"/></a>
          </xsl:if>
        </xsl:if>
      </xsl:for-each>
    </xsl:param>
    <xsl:param name="googleMapsLink">
      <xsl:if test="rdf:RDF/rdf:Description[dcterms:format/rdf:value = 'application/vnd.google-earth.kml+xml']">
        <div><a href="http://maps.google.com/?q={rdf:RDF/rdf:Description/@rdf:about}">View on Google Maps</a></div>
      </xsl:if>
    </xsl:param>
<!--
    <xsl:if test="$resource-type = 'dataset' or $resource-type = 'catalogue'">
-->
      <xsl:variable name="dataset-version">
        <xsl:value-of select="rdf:RDF/rdf:Description[rdf:type/@rdf:resource = 'http://www.w3.org/2004/02/skos/core#ConceptScheme']/owl:versionInfo"/>
      </xsl:variable>
      <xsl:variable name="dataset-issued">
        <xsl:value-of select="/rdf:RDF/rdf:Description[rdf:type/@rdf:resource = 'http://www.w3.org/2004/02/skos/core#ConceptScheme']/dcterms:issued"/>
      </xsl:variable>
      <xsl:variable name="dataset-modified">
        <xsl:value-of select="/rdf:RDF/rdf:Description[rdf:type/@rdf:resource = 'http://www.w3.org/2004/02/skos/core#ConceptScheme']/dcterms:modified"/>
      </xsl:variable>
      <xsl:variable name="dataset-valid-from">
        <xsl:value-of select="/rdf:RDF/rdf:Description[rdf:type/@rdf:resource = 'http://www.w3.org/2004/02/skos/core#ConceptScheme']/wdrs:validfrom"/>
      </xsl:variable>
      <xsl:variable name="dataset-valid-until">
        <xsl:value-of select="/rdf:RDF/rdf:Description[rdf:type/@rdf:resource = 'http://www.w3.org/2004/02/skos/core#ConceptScheme']/wdrs:validuntil"/>
      </xsl:variable>
<!--
    </xsl:if>
-->
<html xml:lang="{$l}" lang="{$l}">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title><xsl:value-of select="$title"/></title>
    <link rel="canonical" href="{$uri}" />
    <xsl:copy-of select="$alternate"/>
    <link type="text/css" rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootswatch/3.3.7/readable/bootstrap.min.css" media="screen"/>
    <link type="text/css" rel="stylesheet" href="https://bootswatch.com/3/assets/css/custom.min.css" media="screen"/>
    <link type="text/css" rel="stylesheet" href="https://cdn.datatables.net/1.10.10/css/dataTables.bootstrap.min.css" media="screen"/>
    <link type="text/css" rel="stylesheet" href="https://cdn.datatables.net/buttons/1.2.4/css/buttons.dataTables.min.css" media="screen"/>
    <link type="text/css" rel="stylesheet" href="https://cdn.datatables.net/select/1.2.1/css/select.dataTables.min.css" media="screen"/>
    <link type="text/css" rel="stylesheet" href="http://getbootstrap.com/docs/3.3/assets/css/docs.min.css"/>
    <link type="text/css" rel="stylesheet" href="http://cdn.leafletjs.com/leaflet/v0.7.7/leaflet.css"/>
    <script type="text/javascript" src="https://code.jquery.com/jquery-1.11.3.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/buttons/1.5.1/js/dataTables.buttons.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/buttons/1.5.1/js/buttons.flash.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/buttons/1.5.1/js/buttons.html5.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/buttons/1.5.1/js/buttons.print.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/select/1.2.7/js/dataTables.select.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/buttons/1.5.2/js/buttons.colVis.min.js"></script> 
    <script type="text/javascript" src="https://getbootstrap.com/docs/3.3/dist/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="https://bootswatch.com/3/assets/js/custom.js"></script>
    <script type="text/javascript" src="http://getbootstrap.com/docs/3.3/assets/js/docs.min.js"></script>
<!--
    <link rel="stylesheet" href="./css/style.css" type="text/css" />
    <link rel="stylesheet" href="./css/map.css" type="text/css" />
-->
    <xsl:if test="$resource-type = 'geometry'">
      <script src="http://cdn.leafletjs.com/leaflet/v0.7.7/leaflet.js"></script>
    </xsl:if>
    <script type="text/javascript">
    //  $("html").css("visibility","hidden");
    </script>
    <script type="text/javascript" src="{$abs_path}js/style.js"></script>
    <script type="text/javascript">
$(document).ready(function() {
  var table = $("table").DataTable( { 
    "scrollY": "500px", "scrollCollapse": true, "paging": false, "dom": "Bfrtip", 
//    "order": [[ 1, "desc" ]],
    "buttons": [ "copy", "csv", "excel", "pdf" ] 
  } );
/*
  table.columns().every( function () {
    var that = this;
    $( "input.filter", this.footer() ).on( "keyup change", function () {
      if ( that.search() !== this.value ) {
        that.search( this.value ).draw();
      }
    } );
  } );
*/    
});
    </script>
    <xsl:if test="$resource-type = 'geometry'">
      <script type="text/javascript" src="../js/map.js"></script>
      <script type="text/javascript" src="../js/script.js"></script>
      <script type="text/javascript">
        var featurecollection = {
          "title": "<xsl:value-of select="$title"/> - <xsl:value-of select="$name"/>",
          "type": "FeatureCollection",
          "features": [ { 
            "geometry": { "type": "GeometryCollection", "geometries": [ <xsl:value-of select="$geojsonas4326"/> ] },
            "type": "Feature",
            "properties": { "popupContent": '<p><xsl:value-of select="$title"/> - <xsl:value-of select="$name"/></p>' }
          } ]
        };
      </script>
    </xsl:if>

    <xsl:if test="$resource-type = 'dataset'">
<script type="application/ld+json">
{
  "@context":"http://schema.org/",
  "@type":"Dataset",
  "@id":"<xsl:value-of select="$uri"/>",
  "name":"<xsl:value-of select="$title"/>",
  "url":"<xsl:value-of select="$uri"/>",
  "sameAs":"<xsl:value-of select="$uri"/>",
  "description":"<xsl:value-of select="$description"/>",
  "includedInDataCatalog":{"@type":"DataCatalog","name":"<xsl:value-of select="$toolacronym"/>","url":"<xsl:value-of select="$base_uri"/>"}
};
</script>
    </xsl:if>

  </head>
  <body>
    <header><h1><xsl:value-of select="$resource-type"/> - <xsl:value-of select="$name"/></h1></header>
    <nav>
      <p><a href="{$abs_path}" title="{$toolname}"><xsl:value-of select="$toolacronym"/></a></p>
      <ul id="actions">
        <li id="classification-name"><a href="{$abs_path}{$code}" title=""><xsl:value-of select="$name"/></a></li>
	<xsl:if test="$version != ''">
          <li id="classification-version"><a href="{$abs_path}{$code}/{$version}" title=""><xsl:value-of select="$version"/></a></li>
        </xsl:if>
	<xsl:if test="rdf:RDF/*/locn:geometry/@rdf:resource">
          <li id="geoiri-edit"><a href="#" title="Geometry of {$title} (as WKT)">Geometry</a></li>
        </xsl:if>
      </ul>
      <ul id="info">
        <li id="format-list"><a href="#" title="Available formats">Formats</a></li>
        <li id="about"><a href="#">About</a></li>
      </ul>
    </nav>
    <xsl:if test="$resource-type = 'dataset' or $resource-type = 'catalogue'">
<!--	    
      <xsl:variable name="dataset-version">
        <xsl:value-of select="rdf:RDF/rdf:Description[rdf:type/@rdf:resource = 'http://www.w3.org/2004/02/skos/core#ConceptScheme']/owl:versionInfo"/>
      </xsl:variable>
      <xsl:variable name="dataset-issued">
        <xsl:value-of select="/rdf:RDF/rdf:Description[rdf:type/@rdf:resource = 'http://www.w3.org/2004/02/skos/core#ConceptScheme']/dcterms:issued"/>
      </xsl:variable>
      <xsl:variable name="dataset-modified">
        <xsl:value-of select="/rdf:RDF/rdf:Description[rdf:type/@rdf:resource = 'http://www.w3.org/2004/02/skos/core#ConceptScheme']/dcterms:modified"/>
      </xsl:variable>
      <xsl:variable name="dataset-valid-from">
        <xsl:value-of select="/rdf:RDF/rdf:Description[rdf:type/@rdf:resource = 'http://www.w3.org/2004/02/skos/core#ConceptScheme']/wdrs:validfrom"/>
      </xsl:variable>
      <xsl:variable name="dataset-valid-until">
        <xsl:value-of select="/rdf:RDF/rdf:Description[rdf:type/@rdf:resource = 'http://www.w3.org/2004/02/skos/core#ConceptScheme']/wdrs:validuntil"/>
      </xsl:variable>
-->
      <section id="dataset-section">
        <h2><xsl:value-of select="$title"/></h2>
        <p><xsl:value-of select="$description"/></p>
	<dl>
	  <xsl:if test="$dataset-version != ''">
            <dt>Version</dt>
	    <dd><p><xsl:value-of select="$dataset-version"/></p></dd>
          </xsl:if>
	  <xsl:if test="$dataset-issued != ''">
            <dt>Publication date</dt>
	    <dd><p><time datetime="{$dataset-issued}"><xsl:value-of select="$dataset-issued"/></time></p></dd>
          </xsl:if>
	  <xsl:if test="$dataset-modified != ''">
            <dt>Last modification date</dt>
	    <dd><p><time datetime="{$dataset-modified}"><xsl:value-of select="$dataset-modified"/></time></p></dd>
          </xsl:if>
	  <xsl:if test="$dataset-valid-from != ''">
            <dt>Valid from</dt>
	    <dd><p><time datetime="{$dataset-valid-from}"><xsl:value-of select="$dataset-valid-from"/></time></p></dd>
          </xsl:if>
	  <xsl:if test="$dataset-valid-until != ''">
            <dt>Valid until</dt>
	    <dd><p><time datetime="{$dataset-valid-until}"><xsl:value-of select="$dataset-valid-until"/></time></p></dd>
          </xsl:if>
          <xsl:if test="rdf:RDF/rdf:Description[rdf:type/@rdf:resource = 'http://www.w3.org/2004/02/skos/core#ConceptScheme' or rdf:type/@rdf:resource = 'http://www.w3.org/ns/dcat#Dataset']/dcterms:isVersionOf/@rdf:resource">
            <dt>Is version of</dt>
            <dd>
              <xsl:for-each select="rdf:RDF/rdf:Description[rdf:type/@rdf:resource = 'http://www.w3.org/2004/02/skos/core#ConceptScheme' or rdf:type/@rdf:resource = 'http://www.w3.org/ns/dcat#Dataset']/dcterms:isVersionOf/@rdf:resource">
                <xsl:variable name="is-version-of-uri" select="."/>
                <xsl:variable name="rel-is-version-of-uri" select="concat($abs_path,substring-after($is-version-of-uri,$base_uri))"/>
		<p><a title="{$is-version-of-uri}" href="{$rel-is-version-of-uri}"><xsl:value-of select="$name"/></a></p>
              </xsl:for-each>
            </dd>
          </xsl:if>
          <xsl:if test="rdf:RDF/rdf:Description[rdf:type/@rdf:resource = 'http://www.w3.org/2004/02/skos/core#ConceptScheme' or rdf:type/@rdf:resource = 'http://www.w3.org/ns/dcat#Dataset']/dcterms:isPartOf/@rdf:resource">
            <dt>Is part of</dt>
            <dd>
              <xsl:for-each select="rdf:RDF/rdf:Description[rdf:type/@rdf:resource = 'http://www.w3.org/2004/02/skos/core#ConceptScheme' or rdf:type/@rdf:resource = 'http://www.w3.org/ns/dcat#Dataset']/dcterms:isPartOf/@rdf:resource">
                <p><a href="{.}"><xsl:value-of select="substring-after(.,$base_uri)"/></a></p>
              </xsl:for-each>
            </dd>
          </xsl:if>
          <xsl:if test="rdf:RDF/rdf:Description[rdf:type/@rdf:resource = 'http://www.w3.org/2004/02/skos/core#ConceptScheme' or rdf:type/@rdf:resource = 'http://www.w3.org/ns/dcat#Dataset']/rdfs:isDefinedBy/@rdf:resource">
            <dt>Is defined by</dt>
            <dd>
              <xsl:for-each select="rdf:RDF/rdf:Description[rdf:type/@rdf:resource = 'http://www.w3.org/2004/02/skos/core#ConceptScheme' or rdf:type/@rdf:resource = 'http://www.w3.org/ns/dcat#Dataset']/rdfs:isDefinedBy/@rdf:resource">
                <p><a href="{.}"><xsl:value-of select="."/></a></p>
              </xsl:for-each>
            </dd>
          </xsl:if>
          <xsl:if test="rdf:RDF/rdf:Description[rdf:type/@rdf:resource = 'http://www.w3.org/2004/02/skos/core#ConceptScheme' or rdf:type/@rdf:resource = 'http://www.w3.org/ns/dcat#Dataset']/dcterms:publisher/@rdf:resource">
            <dt>Publisher</dt>
            <dd>
              <xsl:for-each select="rdf:RDF/rdf:Description[rdf:type/@rdf:resource = 'http://www.w3.org/2004/02/skos/core#ConceptScheme' or rdf:type/@rdf:resource = 'http://www.w3.org/ns/dcat#Dataset']/dcterms:publisher/@rdf:resource">
                <p><a href="{.}"><xsl:value-of select="."/></a></p>
              </xsl:for-each>
            </dd>
          </xsl:if>
        </dl>
        <xsl:if test="rdf:RDF/rdf:Description[rdf:type/@rdf:resource = 'http://www.w3.org/ns/dcat#Catalog']/dcat:dataset/@rdf:resource">
          <section id="catalog-datasets">
          <h3>Datasets</h3>
          <table id="catalog-datasets-table">
            <thead>
              <tr>
                <th>ID</th>
                <th>Title</th>
              </tr>
            </thead>
            <tbody>
              <xsl:for-each select="rdf:RDF/rdf:Description[rdf:type/@rdf:resource = 'http://www.w3.org/ns/dcat#Catalog']/dcat:dataset/@rdf:resource">
                <xsl:variable name="dataset-uri" select="."/>
                <xsl:variable name="rel-dataset-uri" select="concat($abs_path,substring-after($dataset-uri,$base_uri))"/>
                <tr>
<!--		
                  <td><a title="{.}" href="{.}"><xsl:value-of select="substring-after(.,$base_uri)"/></a></td>
-->
		  <td><a title="{$dataset-uri}" href="{$rel-dataset-uri}"><xsl:value-of select="document(concat($root,substring-after($dataset-uri,$base_uri),'/index.rdf'))/rdf:RDF/rdf:Description[rdf:type/@rdf:resource = 'http://www.w3.org/ns/dcat#Dataset']/dcterms:alternative"/></a></td>
		  <td><xsl:value-of select="document(concat($root,substring-after($dataset-uri,$base_uri),'/index.rdf'))/rdf:RDF/rdf:Description[rdf:type/@rdf:resource = 'http://www.w3.org/ns/dcat#Dataset']/dcterms:title"/></td>
                </tr>
              </xsl:for-each>
            </tbody>
          </table>
          </section>
        </xsl:if>
        <xsl:if test="rdf:RDF/rdf:Description[rdf:type/@rdf:resource = 'http://www.w3.org/2004/02/skos/core#ConceptScheme' or rdf:type/@rdf:resource = 'http://www.w3.org/ns/dcat#Dataset']/dcterms:hasVersion/@rdf:resource">
          <section id="dataset-version">
	    <h3>Dataset versions</h3>	  
            <table id="dataset-version-table">
            <thead>
              <tr>
                <th>ID</th>
                <th>Title</th>
              </tr>
            </thead>
            <tbody>
              <xsl:for-each select="rdf:RDF/rdf:Description[rdf:type/@rdf:resource = 'http://www.w3.org/2004/02/skos/core#ConceptScheme' or rdf:type/@rdf:resource = 'http://www.w3.org/ns/dcat#Dataset']/dcterms:hasVersion/@rdf:resource">
                <xsl:variable name="dataset-version-uri" select="."/>
                <xsl:variable name="rel-dataset-version-uri" select="concat($abs_path,substring-after($dataset-version-uri,$base_uri))"/>
                <tr>
		  <td><a title="{$dataset-version-uri}" href="{$rel-dataset-version-uri}"><xsl:value-of select="substring-after($dataset-version-uri,concat($base_uri,$code,'/'))"/></a></td>
<!--
                  <td><a title="{.}" href="{.}"><xsl:value-of select="document(concat($root,substring-after(.,$base_uri),'.rdf'))/rdf:RDF/rdf:Description[rdf:type/@rdf:resource = 'http://www.w3.org/ns/dcat#Dataset']/dcterms:identifier"/></a></td>
-->
		  <td><xsl:value-of select="document(concat($root,substring-after($dataset-version-uri,$base_uri),'.rdf'))/rdf:RDF/rdf:Description[rdf:type/@rdf:resource = 'http://www.w3.org/ns/dcat#Dataset']/dcterms:title"/></td>
                </tr>
              </xsl:for-each>
            </tbody>
            </table>
          </section>
        </xsl:if>
        <xsl:if test="rdf:RDF/rdf:Description[rdf:type/@rdf:resource = 'http://www.w3.org/2004/02/skos/core#ConceptScheme' or rdf:type/@rdf:resource = 'http://www.w3.org/ns/dcat#Dataset']/dcterms:hasPart/@rdf:resource">
          <section id="subdataset">
          <h3>Sub-datasets</h3>
          <table id="subdataset-table">
            <thead>
              <tr>
                <th>ID</th>
                <th>Title</th>
              </tr>
            </thead>
            <tbody>
              <xsl:for-each select="rdf:RDF/rdf:Description[rdf:type/@rdf:resource = 'http://www.w3.org/2004/02/skos/core#ConceptScheme' or rdf:type/@rdf:resource = 'http://www.w3.org/ns/dcat#Dataset']/dcterms:hasPart/@rdf:resource">
                <xsl:variable name="subdataset-uri" select="."/>
                <xsl:variable name="rel-subdataset-uri" select="concat($abs_path,substring-after($subdataset-uri,$base_uri))"/>
                <tr>
		  <td><a title="{$subdataset-uri}" href="{$rel-subdataset-uri}"><xsl:value-of select="$subdataset-uri"/></a></td>
<!--
		  <td><a title="{.}" href="{.}"><xsl:value-of select="document(concat($root,substring-after(.,$base_uri),'.rdf'))/rdf:RDF/rdf:Description[rdf:type/@rdf:resource = 'http://www.w3.org/ns/dcat#Dataset']/dcterms:identifier"/></a></td>
-->
		  <td><xsl:value-of select="document(concat($root,substring-after($subdataset-uri,$base_uri),'.rdf'))/rdf:RDF/rdf:Description[rdf:type/@rdf:resource = 'http://www.w3.org/ns/dcat#Dataset']/dcterms:title"/></td>
                </tr>
              </xsl:for-each>
            </tbody>
          </table>
          </section>
        </xsl:if>
        <xsl:if test="rdf:RDF/rdf:Description[rdf:type/@rdf:resource = 'http://www.w3.org/2004/02/skos/core#ConceptScheme']/skos:hasTopConcept/@rdf:resource">
          <section id="top-concepts">
            <h3>Top Concepts</h3>
          <table id="top-concepts-table">
<!--		    
	    <caption>Top Concepts</caption>
-->
            <thead>
              <tr>
                <th>ID</th>
                <th>Name</th>
              </tr>
            </thead>
	    <tbody>
              <xsl:for-each select="rdf:RDF/rdf:Description[rdf:type/@rdf:resource = 'http://www.w3.org/2004/02/skos/core#ConceptScheme']/skos:hasTopConcept/@rdf:resource">
                <xsl:variable name="top-concept-uri" select="."/>
                <xsl:variable name="rel-top-concept-uri" select="concat($abs_path,substring-after($top-concept-uri,$base_uri))"/>
<!--		    
                <tr>
                  <td><a href="{.}"><xsl:value-of select="."/></a></td>
                </tr>
              </xsl:for-each>
	      <xsl:for-each select="rdf:RDF/rdf:Description[rdf:type/@rdf:resource = 'http://www.w3.org/2004/02/skos/core#Concept']">
-->
                <tr>
                  <td><a href="{$rel-top-concept-uri}" title="{$top-concept-uri}"><xsl:value-of select="/*//*[@rdf:about = $top-concept-uri]/dcterms:identifier"/></a></td>
                  <td><xsl:value-of select="/*//*[@rdf:about = $top-concept-uri]/skos:prefLabel"/></td>
                </tr>
              </xsl:for-each>
            </tbody>
          </table>
          </section>
        </xsl:if>
        <xsl:if test="rdf:RDF/rdf:Description[rdf:type/@rdf:resource = 'http://www.w3.org/2004/02/skos/core#ConceptScheme']/skos:hasTopConcept/@rdf:resource">
          <section id="concepts">
            <h3>Concepts</h3>
	    <table id="concepts">
<!--
	    <caption>Concepts</caption>
-->
            <thead>
              <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Broader</th>
              </tr>
            </thead>
	    <tbody>
	      <xsl:for-each select="rdf:RDF/rdf:Description[rdf:type/@rdf:resource = 'http://www.w3.org/2004/02/skos/core#Concept']">
                <xsl:variable name="concept-uri" select="@rdf:about"/>
                <xsl:variable name="rel-concept-uri" select="concat($abs_path,substring-after($concept-uri,$base_uri))"/>
                <tr>
                  <td><a href="{$rel-concept-uri}" title="{$concept-uri}"><xsl:value-of select="dcterms:identifier"/></a></td>
                  <td><xsl:value-of select="skos:prefLabel"/></td>
		  <td>
		    <xsl:for-each select="skos:broader">
                      <xsl:variable name="broader_uri" select="@rdf:resource"/>
                      <xsl:variable name="rel-broader_uri" select="concat($abs_path,substring-after($broader_uri,$base_uri))"/>
<!--		    
		      <xsl:variable name="broader_id" select="/*//*[@rdf:about = $broader_uri]/dcterms:identifier"/>
		      <xsl:variable name="broader_name" select="/*//*[@rdf:about = $broader_uri]/skos:prefLabel"/>
	              <a href="{$broader_uri}" title="{$broader_uri}"><xsl:value-of select="concat($broader_id,' - ',$broader_name)"/></a>
-->
		      <a href="{$rel-broader_uri}" title="{$broader_uri}"><xsl:value-of select="substring-after($broader_uri,concat($base_uri,$code,'/',$version,'/'))"/></a>
		    </xsl:for-each>
		  </td>
                </tr>
              </xsl:for-each>
            </tbody>
          </table>
          </section>
        </xsl:if>
      </section>
    </xsl:if>
    <xsl:if test="$resource-type = 'dataset-item'">
      <section id="dataset-item-section">
        <h2><xsl:value-of select="$id"/> - <xsl:value-of select="$title"/></h2>
        <p><xsl:value-of select="$description"/></p>
	<dl>
	  <xsl:if test="normalize-space($core-content-note) != ''">
            <dt>Core content note</dt>
            <dd>
              <p><xsl:value-of select="$core-content-note"/></p>
            </dd>
          </xsl:if>
	  <xsl:if test="normalize-space($exclusion-note) != ''">
            <dt>Exclusion note</dt>
            <dd>
              <p><xsl:value-of select="$exclusion-note"/></p>
            </dd>
          </xsl:if>
          <dt>In scheme</dt>
          <dd>
            <xsl:for-each select="rdf:RDF/*/skos:inScheme">
              <xsl:variable name="concept-scheme-uri" select="@rdf:resource"/>
              <xsl:variable name="rel-concept-scheme-uri" select="concat($abs_path,substring-after($concept-scheme-uri,$base_uri))"/>
              <p><a title="{$concept-scheme-uri}" href="{$rel-concept-scheme-uri}"><xsl:value-of select="concat($name,' / ',$version)"/></a></p>
            </xsl:for-each>
          </dd>
          <xsl:if test="rdf:RDF/*/skos:broader">
            <dt>Broader</dt>
            <dd>
              <xsl:for-each select="rdf:RDF/*/skos:broader">
                <xsl:variable name="concept-broader-uri" select="@rdf:resource"/>
                <xsl:variable name="rel-concept-broader-uri" select="concat($abs_path,substring-after($concept-broader-uri,$base_uri))"/>
		<p><a title="{$concept-broader-uri}" href="{$rel-concept-broader-uri}"><xsl:value-of select="substring-after($concept-broader-uri,concat($base_uri,$code,'/',$version,'/'))"/></a></p>
              </xsl:for-each>
            </dd>
          </xsl:if>
          <xsl:if test="rdf:RDF/*/skos:narrower">
            <dt>Narrower</dt>
            <dd>
              <xsl:for-each select="rdf:RDF/*/skos:narrower">
                <xsl:variable name="concept-narrower-uri" select="@rdf:resource"/>
                <xsl:variable name="rel-concept-narrower-uri" select="concat($abs_path,substring-after($concept-narrower-uri,$base_uri))"/>
		<p><a title="{$concept-narrower-uri}" href="{$rel-concept-narrower-uri}"><xsl:value-of select="substring-after($concept-narrower-uri,concat($base_uri,$code,'/',$version,'/'))"/></a></p>
              </xsl:for-each>
            </dd>
          </xsl:if>
	  <xsl:if test="rdf:RDF/*/geo:lat">
	  <dt>Centroid</dt>
          <dd>
            <p>Latitude: <xsl:value-of select="rdf:RDF/*/geo:lat"/></p>
            <p>Longitude: <xsl:value-of select="rdf:RDF/*/geo:long"/></p>
          </dd>
          </xsl:if>
	  <xsl:if test="rdf:RDF/*/locn:geometry/@rdf:resource">
	  <dt>Polygon</dt>
          <dd>
            <p><a href="{rdf:RDF/*/locn:geometry/@rdf:resource}"><xsl:value-of select="rdf:RDF/*/locn:geometry/@rdf:resource"/></a></p>
          </dd>
          </xsl:if>
	  <xsl:if test="rdf:RDF/*/locn:postCode">
          <dt>Postcodes</dt>
          <dd>
            <xsl:for-each select="rdf:RDF/*/locn:postCode">
              <span><xsl:value-of select="."/></span><xsl:text> </xsl:text>
            </xsl:for-each>
          </dd>
          </xsl:if>
        </dl>
      </section>
    </xsl:if>
    <xsl:if test="$resource-type = 'geometry'">
    <section id="map-box">
      <div id="map"></div>
    </section>
    <section id="geoiri-section">
      <form id="geoiri">
        <h4>
          <label for="geometry-wkt"><xsl:value-of select="$title"/> (as <a href="https://en.wikipedia.org/wiki/Well-known_text" target="_blank" title="Well-Known Text (Wikipedia)">WKT</a>)</label>
        </h4>
        <div id="geometry-wkt-box">
<!--
          <p id="geometry-wkt-help" class="help">Type or copy &amp; paste a WKT-encoded geometry</p>
-->
          <textarea readonly="readonly" id="geometry-wkt" rows="10" style="resize:vertical;" placeholder=""><xsl:value-of select="$wkt"/></textarea>
        </div>
        <div id="srid-box">
          <label for="srid"><a class="info" href="http://www.epsg-registry.org/" target="_blank" title="Click here for the list of EPSG coordinate reference systems."></a> EPSG</label>
          <input readonly="readonly" type="text" title="Coordinate Reference System" id="srid" value="{$srs}" minLength="4" maxLength="8"/>
        </div>
<!--
        <input type="submit" id="getgeoiri" value="Get GeoIRI"/>
-->
      </form>
    </section>
    </xsl:if>
    <section id="format-list-section">
      <h4>Available formats</h4>
      <div>
        <p>Representations of this data are also available in the following encodings:</p>
        <div id="format-list-rdf">
          <xsl:copy-of select="$formatListRDF"/>
        </div>
        <div id="format-list-others">
          <xsl:copy-of select="$formatListOthers"/>
        </div>
      </div>
    </section>
    <section id="about-section">
      <h4>About <xsl:value-of select="$toolacronym"/></h4>
      <div>
        <p><xsl:value-of select="$aboutText"/></p>
	<p>For more information: <a target="_blank" href="{$aboutUrl}"><xsl:value-of select="$toolacronym"/> @ GitHub</a></p>
	<p id="licence">This data is published under a <a target="_blank" href="{$licenceUrl}"><xsl:value-of select="$licenceName"/></a> licence.</p>
      </div>
    </section>
    <aside>
    </aside>
    <footer>
<!--	    
      <p id="licence">This data is published under a <a target="_blank" href="{$licenceUrl}"><xsl:value-of select="$licenceName"/></a> licence.</p>
-->
    </footer>
   </body>
</html>

  </xsl:template>

</xsl:transform>
