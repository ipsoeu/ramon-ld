<?xml version="1.0" encoding="UTF-8"?>

<!--  

  Copyright 2017-2020 EUROPEAN UNION
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

<!--

  PURPOSE AND USAGE

  This XSLT is a proof of concept for the RDF representation of the code lists from
  the EUROSTAT's RAMON registry.
    
  As such, this XSLT must be considered as unstable, and can be updated any 
  time.
  
-->

<xsl:transform
    xmlns:adms   = "http://www.w3.org/ns/adms#"
    xmlns:cnt    = "http://www.w3.org/2011/content#"
    xmlns:dc     = "http://purl.org/dc/elements/1.1/" 
    xmlns:dct    = "http://purl.org/dc/terms/"
    xmlns:dctype = "http://purl.org/dc/dcmitype/"
    xmlns:dcat   = "http://www.w3.org/ns/dcat#"
    xmlns:duv    = "http://www.w3.org/ns/duv#"
    xmlns:earl   = "http://www.w3.org/ns/earl#"
    xmlns:foaf   = "http://xmlns.com/foaf/0.1/"
    xmlns:frapo  = "http://purl.org/cerif/frapo/"
    xmlns:geo    = "http://www.w3.org/2003/01/geo/wgs84_pos#"
    xmlns:gsp    = "http://www.opengis.net/ont/geosparql#"
    xmlns:locn   = "http://www.w3.org/ns/locn#"
    xmlns:oa     = "http://www.w3.org/ns/oa#"
    xmlns:org    = "http://www.w3.org/ns/org#"
    xmlns:owl    = "http://www.w3.org/2002/07/owl#"
    xmlns:prov   = "http://www.w3.org/ns/prov#"
    xmlns:rdf    = "http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs   = "http://www.w3.org/2000/01/rdf-schema#"
    xmlns:schema = "http://schema.org/"
    xmlns:skos   = "http://www.w3.org/2004/02/skos/core#"
    xmlns:vcard  = "http://www.w3.org/2006/vcard/ns#"
    xmlns:xkos   = "http://rdf-vocabulary.ddialliance.org/xkos#"
    xmlns:xsd    = "http://www.w3.org/2001/XMLSchema#" 
    xmlns:wdrs   = "http://www.w3.org/2007/05/powder-s#"

    xmlns:xlink  = "http://www.w3.org/1999/xlink" 
    xmlns:xsi    = "http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:xsl    = "http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes = "xlink xsi xsl"
    version="1.0">

  <xsl:output method="xml"
              indent="yes"
              encoding="utf-8"
              cdata-section-elements="locn:geometry" />

<!-- Vars used when transforming strings into upper/lowercase. -->

    <xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'"/>
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
    
<!-- The classification URI -->

    <xsl:param name="classification-uri">http://data.europa.eu/nuts/</xsl:param>

<!-- The classification publisher -->

    <xsl:param name="classification-publisher">http://publications.europa.eu/resource/authority/corporate-body/ESTAT</xsl:param>

<!--

  Mapping parameters
  ==================
  
  This section includes mapping parameters to be modified manually. 

-->

<!-- Parameter $profile -->
<!--

  This parameter specifies the DataCite+DCAT-AP profile to be used:
  - value "core": the DataCite+DCAT-AP Core profile, which includes only the DataCite metadata elements supported in DCAT-AP
  - value "extended": the DataCite+DCAT-AP Extended profile, which defines mappings for all the DataCite metadata elements
  
  The current specifications for the core and extended DataCite+DCAT-AP profiles are available on the European Commission's 
  Git repository:

    https://webgate.ec.europa.eu/CITnet/stash/projects/ODCKAN/repos/datacite-to-dcat-ap/

-->

<!-- Uncomment to use DataCite+DCAT-AP Core -->
<!--
  <xsl:param name="profile">core</xsl:param>
-->
<!-- Uncomment to use DataCite+DCAT-AP Extended -->
  <xsl:param name="profile">extended</xsl:param>

<!--

  Other global parameters
  =======================
  
-->  
  
<!-- Namespaces -->

  <xsl:param name="xsd">http://www.w3.org/2001/XMLSchema#</xsl:param>
  <xsl:param name="dct">http://purl.org/dc/terms/</xsl:param>
  <xsl:param name="dctype">http://purl.org/dc/dcmitype/</xsl:param>
  <xsl:param name="foaf">http://xmlns.com/foaf/0.1/</xsl:param>
  <xsl:param name="gsp">http://www.opengis.net/ont/geosparql#</xsl:param>
  <xsl:param name="skos">http://www.w3.org/2004/02/skos/core#</xsl:param>
  <xsl:param name="vcard">http://www.w3.org/2006/vcard/ns#</xsl:param>
<!-- Currently not used.
  <xsl:param name="timeUri">http://placetime.com/</xsl:param>
  <xsl:param name="timeInstantUri" select="concat($timeUri,'instant/gregorian/')"/>
  <xsl:param name="timeIntervalUri" select="concat($timeUri,'interval/gregorian/')"/>
-->  
  <xsl:param name="dcat">http://www.w3.org/ns/dcat#</xsl:param>
  <xsl:param name="gsp">http://www.opengis.net/ont/geosparql#</xsl:param>

<!-- MDR NALs and other code lists -->

  <xsl:param name="op">http://publications.europa.eu/resource/authority/</xsl:param>
  <xsl:param name="oplang" select="concat($op,'language/')"/>
  <xsl:param name="opcb" select="concat($op,'corporate-body/')"/>
  <xsl:param name="oplic" select="concat($op,'licence/')"/>
  <xsl:param name="opar" select="concat($op,'access-right/')"/>
<!--  
  <xsl:param name="opcountry" select="concat($op,'country/')"/>
  <xsl:param name="opfq" select="concat($op,'frequency/')"/>
  <xsl:param name="cldFrequency">http://purl.org/cld/freq/</xsl:param>
-->  
  <xsl:param name="ianaMT">https://www.iana.org/assignments/media-types/</xsl:param>
<!-- This is used as the datatype for the GeoJSON-based encoding of the bounding box. -->
  <xsl:param name="geojsonMediaTypeUri">https://www.iana.org/assignments/media-types/application/vnd.geo+json</xsl:param>

<!-- INSPIRE code list URIs -->  
<!--  
  <xsl:param name="INSPIRECodelistUri">http://inspire.ec.europa.eu/metadata-codelist/</xsl:param>
  <xsl:param name="SpatialDataServiceCategoryCodelistUri" select="concat($INSPIRECodelistUri,'SpatialDataServiceCategory')"/>
  <xsl:param name="DegreeOfConformityCodelistUri" select="concat($INSPIRECodelistUri,'DegreeOfConformity')"/>
  <xsl:param name="ResourceTypeCodelistUri" select="concat($INSPIRECodelistUri,'ResourceType')"/>
  <xsl:param name="ResponsiblePartyRoleCodelistUri" select="concat($INSPIRECodelistUri,'ResponsiblePartyRole')"/>
  <xsl:param name="SpatialDataServiceTypeCodelistUri" select="concat($INSPIRECodelistUri,'SpatialDataServiceType')"/>
  <xsl:param name="TopicCategoryCodelistUri" select="concat($INSPIRECodelistUri,'TopicCategory')"/>
-->
<!-- INSPIRE code list URIs (not yet supported; the URI pattern is tentative) -->  
<!--  
  <xsl:param name="SpatialRepresentationTypeCodelistUri" select="concat($INSPIRECodelistUri,'SpatialRepresentationTypeCode')"/>
  <xsl:param name="MaintenanceFrequencyCodelistUri" select="concat($INSPIRECodelistUri,'MaintenanceFrequencyCode')"/>
-->
<!-- 

  Master template     
  ===============
 
 -->
 
  <xsl:template match="/">
    <rdf:RDF>
      <xsl:apply-templates select="*//*[local-name() = 'Classification']"/>
    </rdf:RDF>
  </xsl:template>
  
  <xsl:template name="classification-legal-basis">
    <xsl:param name="id"/>
    <xsl:choose>
      <xsl:when test="$id = 'CL_COFOG99'">
        <rdfs:isDefinedBy rdf:resource="http://data.europa.eu/eli/reg/2011/31/oj"/>
      </xsl:when>
      <xsl:when test="$id = 'NUTS_33'">
        <rdfs:isDefinedBy rdf:resource="http://data.europa.eu/eli/reg/2011/31/oj"/>
      </xsl:when>
      <xsl:when test="$id = 'NUTS_2013'">
        <rdfs:isDefinedBy rdf:resource="http://data.europa.eu/eli/reg/2013/1319/oj"/>
      </xsl:when>
      <xsl:when test="$id = 'NUTS_2016'">
        <rdfs:isDefinedBy rdf:resource="http://data.europa.eu/eli/reg/2016/2066/oj"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="classification-version">
    <xsl:param name="id"/>
    <xsl:choose>
      <xsl:when test="$id = 'CL_COFOG99'">
        <xsl:value-of select="'1999'"/>
      </xsl:when>
      <xsl:when test="$id = 'NUTS_33'">
        <xsl:value-of select="'2010'"/>
      </xsl:when>
      <xsl:when test="$id = 'NUTS_2013'">
        <xsl:value-of select="'2013'"/>
      </xsl:when>
      <xsl:when test="$id = 'NUTS_2016'">
        <xsl:value-of select="'2016'"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="classification-issue-date">
    <xsl:param name="id"/>
    <xsl:choose>
      <xsl:when test="$id = 'CL_COFOG99'">
        <dct:issued rdf:datatype="{$xsd}date">1999-01-01</dct:issued>
      </xsl:when>
      <xsl:when test="$id = 'NUTS_33'">
        <dct:issued rdf:datatype="{$xsd}date">2011-02-07</dct:issued>
      </xsl:when>
      <xsl:when test="$id = 'NUTS_2013'">
        <dct:issued rdf:datatype="{$xsd}date">2014-08-08</dct:issued>
      </xsl:when>
      <xsl:when test="$id = 'NUTS_2016'">
        <dct:issued rdf:datatype="{$xsd}date">2016-12-19</dct:issued>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="classification-validity">
    <xsl:param name="id"/>
    <xsl:choose>
      <xsl:when test="$id = 'CL_COFOG99'">
        <dct:valid rdf:datatype="{$xsd}date">1999-01-01</dct:valid>
        <wdrs:validfrom rdf:datatype="{$xsd}date">1999-01-01</wdrs:validfrom>
      </xsl:when>
      <xsl:when test="$id = 'NUTS_33'">
        <dct:valid>2012-01-01/2014-12-31</dct:valid>
        <wdrs:validfrom rdf:datatype="{$xsd}date">2012-01-01</wdrs:validfrom>
        <wdrs:validuntil rdf:datatype="{$xsd}date">2014-12-31</wdrs:validuntil>
      </xsl:when>
      <xsl:when test="$id = 'NUTS_2013'">
        <dct:valid>2015-01-01/2017-12-31</dct:valid>
        <wdrs:validfrom rdf:datatype="{$xsd}date">2015-01-01</wdrs:validfrom>
        <wdrs:validuntil rdf:datatype="{$xsd}date">2017-12-31</wdrs:validuntil>
      </xsl:when>
      <xsl:when test="$id = 'NUTS_2016'">
        <dct:valid rdf:datatype="{$xsd}date">2018-01-01</dct:valid>
        <wdrs:validfrom rdf:datatype="{$xsd}date">2018-01-01</wdrs:validfrom>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="uri">
    <xsl:param name="id"/>
    <xsl:param name="version">
      <xsl:call-template name="classification-version">
        <xsl:with-param name="id" select="$id"/>
      </xsl:call-template>
    </xsl:param>
    <xsl:value-of select="concat($classification-uri, $version)"/>
  </xsl:template>

  <xsl:template match="*//*[local-name() = 'Classification']">
    <xsl:param name="id"><xsl:value-of select="@id"/></xsl:param>
    <xsl:param name="uri">
      <xsl:call-template name="uri">
        <xsl:with-param name="id" select="$id"/>
      </xsl:call-template>
    </xsl:param>
    <rdf:Description rdf:about="{$uri}">
      <rdf:type rdf:resource="{$skos}ConceptScheme"/>
      <rdf:type rdf:resource="{$dcat}Dataset"/>
      <dct:identifier rdf:datatype="{$xsd}string"><xsl:value-of select="$id"/></dct:identifier>
      <dct:isVersionOf rdf:resource="{$classification-uri}"/>
      <owl:versionInfo>
        <xsl:call-template name="classification-version">
          <xsl:with-param name="id" select="$id"/>
        </xsl:call-template>
      </owl:versionInfo>
      <xsl:for-each select="*[local-name() = 'Label']/*[local-name() = 'LabelText']">
        <xsl:variable name="language"><xsl:value-of select="translate(@language, $uppercase, $lowercase)"/></xsl:variable>
        <dct:title xml:lang="{$language}"><xsl:value-of select="normalize-space(.)"/></dct:title>
      </xsl:for-each>
      <xsl:for-each select="*[local-name() = 'Property']/*[local-name() = 'PropertyQualifier']/*[local-name() = 'PropertyText']">
        <xsl:variable name="language"><xsl:value-of select="translate(../@language, $uppercase, $lowercase)"/></xsl:variable>
        <dct:description xml:lang="{$language}"><xsl:value-of select="normalize-space(.)"/></dct:description>
      </xsl:for-each>
      <dct:publisher rdf:resource="{$classification-publisher}"/>
      <xsl:call-template name="classification-issue-date">
        <xsl:with-param name="id" select="$id"/>
      </xsl:call-template>
      <xsl:call-template name="classification-validity">
        <xsl:with-param name="id" select="$id"/>
      </xsl:call-template>
      <xsl:call-template name="classification-legal-basis">
        <xsl:with-param name="id" select="$id"/>
      </xsl:call-template>
      <xsl:for-each select="*[local-name() = 'Item' and @idLevel = '1']">
<!--	      
	<skos:hasTopConcept rdf:resource="{$uri}/{*[local-name() = 'Label' and @qualifier = 'Usual']/*[local-name() = 'LabelText' and @language = 'ALL']}"/>
-->
      <xsl:choose>
        <xsl:when test="*[local-name() = 'Label' and @qualifier = 'Usual']/*[local-name() = 'LabelText' and @language = 'ALL']">
	  <skos:hasTopConcept rdf:resource="{$uri}/{*[local-name() = 'Label' and @qualifier = 'Usual']/*[local-name() = 'LabelText' and @language = 'ALL']}"/>
        </xsl:when>
        <xsl:when test="*[local-name() = 'Label' and @qualifier = 'Usual']/*[local-name() = 'LabelText']">
	  <skos:hasTopConcept rdf:resource="{$uri}/{translate(*[local-name() = 'Label' and @qualifier = 'Usual']/*[local-name() = 'LabelText'],' ','_')}"/>
        </xsl:when>
      </xsl:choose>
      </xsl:for-each>
    </rdf:Description>
    <xsl:apply-templates select="*[local-name() = 'Item']">
      <xsl:with-param name="scheme-id" select="$id"/>
      <xsl:with-param name="uri" select="$uri"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="*[local-name() = 'Item']">
    <xsl:param name="scheme-id"/>
    <xsl:param name="uri"/>
    <xsl:param name="position" select="position()"/>
    <xsl:param name="id">
      <xsl:choose>
        <xsl:when test="*[local-name() = 'Label' and @qualifier = 'Usual']/*[local-name() = 'LabelText' and @language = 'ALL']">
          <xsl:value-of select="*[local-name() = 'Label' and @qualifier = 'Usual']/*[local-name() = 'LabelText' and @language = 'ALL']"/>
        </xsl:when>
        <xsl:when test="*[local-name() = 'Label' and @qualifier = 'Usual']/*[local-name() = 'LabelText']">
          <xsl:value-of select="translate(*[local-name() = 'Label' and @qualifier = 'Usual']/*[local-name() = 'LabelText'],' ','_')"/>
        </xsl:when>
      </xsl:choose>
    </xsl:param>
    <xsl:param name="idLevel"><xsl:value-of select="@idLevel"/></xsl:param>
    <rdf:Description rdf:about="{$uri}/{$id}">
      <skos:inScheme rdf:resource="{$uri}"/>
      <rdf:type rdf:resource="{$skos}Concept"/>
<!--
      <rdf:type rdf:resource="{$dct}Location"/>
      <rdf:type rdf:resource="{$gsp}Feature"/>
-->
      <dct:identifier rdf:datatype="{$xsd}string"><xsl:value-of select="$id"/></dct:identifier>
      <skos:notation rdf:datatype="{$xsd}string"><xsl:value-of select="$id"/></skos:notation>
      <xsl:for-each select="*[local-name() = 'Label']/*[local-name() = 'LabelText' and @language != 'ALL']">
        <xsl:variable name="language"><xsl:value-of select="translate(@language, $uppercase, $lowercase)"/></xsl:variable>
        <skos:prefLabel xml:lang="{$language}"><xsl:value-of select="normalize-space(.)"/></skos:prefLabel>
      </xsl:for-each>
      <xsl:for-each select="*[local-name() = 'Property' and @name = 'ExplanatoryNote']/*[local-name() = 'PropertyQualifier' and @name = 'CentralContent']/*[local-name() = 'PropertyText']">
        <xsl:variable name="language"><xsl:value-of select="translate(../@language, $uppercase, $lowercase)"/></xsl:variable>
        <skos:definition xml:lang="{$language}"><xsl:value-of select="normalize-space(.)"/></skos:definition>
      </xsl:for-each>
      <xsl:for-each select="*[local-name() = 'Property' and @name = 'ExplanatoryNote']/*[local-name() = 'PropertyQualifier' and @name = 'CentralContent']/*[local-name() = 'PropertyText']">
        <xsl:variable name="language"><xsl:value-of select="translate(../@language, $uppercase, $lowercase)"/></xsl:variable>
        <xkos:coreContentNote xml:lang="{$language}"><xsl:value-of select="normalize-space(.)"/></xkos:coreContentNote>
      </xsl:for-each>
      <xsl:for-each select="*[local-name() = 'Property' and @name = 'ExplanatoryNote']/*[local-name() = 'PropertyQualifier' and @name = 'LimitContent']/*[local-name() = 'PropertyText']">
        <xsl:variable name="language"><xsl:value-of select="translate(../@language, $uppercase, $lowercase)"/></xsl:variable>
        <xkos:additionalContentNote xml:lang="{$language}"><xsl:value-of select="normalize-space(.)"/></xkos:additionalContentNote>
      </xsl:for-each>
      <xsl:for-each select="*[local-name() = 'Property' and @name = 'ExplanatoryNote']/*[local-name() = 'PropertyQualifier' and @name = 'Exclusions']/*[local-name() = 'PropertyText']">
        <xsl:variable name="language"><xsl:value-of select="translate(../@language, $uppercase, $lowercase)"/></xsl:variable>
        <xkos:exclusionNote xml:lang="{$language}"><xsl:value-of select="normalize-space(.)"/></xkos:exclusionNote>
      </xsl:for-each>
      <xsl:if test="$idLevel = '1'">
        <skos:topConceptOf rdf:resource="{$uri}"/>
      </xsl:if>
      
      <xsl:for-each select="/*//*[local-name() = 'Item']">
        <xsl:choose>
          <xsl:when test="$idLevel = @idLevel - 1 and starts-with(normalize-space(*[local-name() = 'Label' and @qualifier = 'Usual']/*[local-name() = 'LabelText' and @language = 'ALL']), $id)">
            <skos:narrower rdf:resource="{$uri}/{normalize-space(*[local-name() = 'Label' and @qualifier = 'Usual']/*[local-name() = 'LabelText' and @language = 'ALL'])}"/>
          </xsl:when>
          <xsl:when test="$idLevel = @idLevel + 1 and starts-with($id, normalize-space(*[local-name() = 'Label' and @qualifier = 'Usual']/*[local-name() = 'LabelText' and @language = 'ALL']))">
            <skos:broader rdf:resource="{$uri}/{normalize-space(*[local-name() = 'Label' and @qualifier = 'Usual']/*[local-name() = 'LabelText' and @language = 'ALL'])}"/>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
      
      <xsl:variable name="ref-level">
        <xsl:choose>
          <xsl:when test="$scheme-id = 'NACE_REV1'">
            <xsl:text>2</xsl:text>
          </xsl:when>
          <xsl:when test="$scheme-id = 'NACE_1_1'">
            <xsl:text>2</xsl:text>
          </xsl:when>
          <xsl:when test="$scheme-id = 'NACE_REV2'">
            <xsl:text>1</xsl:text>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
<!--      
      <xsl:choose>
        <xsl:when test="@idLevel = number($ref-level)">
          <xsl:call-template name="narrowers">
            <xsl:with-param name="uri" select="$uri"/>
            <xsl:with-param name="position" select="position()"/>
            <xsl:with-param name="idLevel" select="@idLevel"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="@idLevel = number($ref-level) + 1">
          <xsl:call-template name="broaders">
            <xsl:with-param name="uri" select="$uri"/>
            <xsl:with-param name="position" select="position()"/>
            <xsl:with-param name="idLevel" select="@idLevel"/>
          </xsl:call-template>
        </xsl:when>
      </xsl:choose>
-->      
    </rdf:Description>
  </xsl:template>
  
  <xsl:template name="broaders">
    <xsl:param name="uri"/>
    <xsl:param name="position"/>
    <xsl:param name="idLevel"/>
    <xsl:param name="next-position" select="number($position) - 1"/>
    <xsl:variable name="id" select="/*//*[local-name() = 'Item'][number($next-position)]/*[local-name() = 'Label' and @qualifier = 'Usual']/*[local-name() = 'LabelText' and @language = 'ALL']"/>
    <xsl:variable name="currentIdLevel" select="/*//*[local-name() = 'Item'][number($next-position)]/@idLevel"/>
    <xsl:choose>
      <xsl:when test="$idLevel = $currentIdLevel + 1">
        <skos:broader rdf:resource="{$uri}/{$id}"/>
      </xsl:when>
      <xsl:when test="$idLevel &lt; $currentIdLevel or $idLevel = $currentIdLevel">
        <xsl:call-template name="broaders">
          <xsl:with-param name="uri" select="$uri"/>
          <xsl:with-param name="position" select="$next-position"/>
          <xsl:with-param name="idLevel" select="$idLevel"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="narrowers">
    <xsl:param name="uri"/>
    <xsl:param name="position"/>
    <xsl:param name="idLevel"/>
    <xsl:param name="next-position" select="number($position) + 1"/>
    <xsl:variable name="id" select="/*//*[local-name() = 'Item'][number($next-position)]/@id"/>
    <xsl:variable name="currentIdLevel" select="/*//*[local-name() = 'Item'][number($next-position)]/@idLevel"/>
    <xsl:if test="$idLevel &lt; $currentIdLevel or $idLevel = $currentIdLevel">
      <xsl:if test="$idLevel = $currentIdLevel - 1">
        <skos:narrower rdf:resource="{$uri}/{$id}"/>
      </xsl:if>
      <xsl:call-template name="narrowers">
        <xsl:with-param name="uri" select="$uri"/>
        <xsl:with-param name="position" select="$next-position"/>
        <xsl:with-param name="idLevel" select="$idLevel"/>
      </xsl:call-template>
    </xsl:if>
<!--
    <xsl:choose>
      <xsl:when test="$idLevel &gt;= $currentIdLevel">
     
        <xsl:call-template name="narrowers">
          <xsl:with-param name="uri" select="$uri"/>
          <xsl:with-param name="position" select="$next-position"/>
          <xsl:with-param name="idLevel" select="$idLevel"/>
        </xsl:call-template>
       
      </xsl:when>
      <xsl:when test="$idLevel = $currentIdLevel - 1">
        <skos:narrower rdf:resource="{$uri}/{$id}"/>
     
        <xsl:call-template name="narrowers">
          <xsl:with-param name="uri" select="$uri"/>
          <xsl:with-param name="position" select="$next-position"/>
          <xsl:with-param name="idLevel" select="$idLevel"/>
        </xsl:call-template>
     
      </xsl:when>
    </xsl:choose>
-->    
  </xsl:template>

  
</xsl:transform>
