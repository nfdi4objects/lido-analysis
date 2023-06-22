<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.lido-schema.org"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:doap="http://usefulinc.com/ns/doap#"
    xmlns:edm="http://www.europeana.eu/schemas/edm/"
    xmlns:foaf="http://xmlns.com/foaf/0.1/"
    xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#"
    xmlns:lido="http://www.lido-schema.org"
    xmlns:nm="http://nomisma.org/id/"
    xmlns:nmo="http://nomisma.org/ontology#"
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:svcs="http://rdfs.org/sioc/services#"
    xmlns:void="http://rdfs.org/ns/void#"
  >
  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="/">
    <rdf:RDF>
      <xsl:apply-templates select="*/lido:lido"/>
    </rdf:RDF>
  </xsl:template>

  <xsl:template match="lido:lido">
    <nmo:NumismaticObject>
       <xsl:attribute name="rdf:about">
          <xsl:value-of select="lido:objectPublishedID[@lido:type='http://terminology.lido-schema.org/identifier_type/uri']"/>
       </xsl:attribute>
       <xsl:apply-templates select="*"/>
    </nmo:NumismaticObject>
   </xsl:template>            

   <xsl:template match="lido:category">
     <rdf:type rdf:resource="{lido:conceptID}"/>
   </xsl:template>            

   <xsl:template match="lido:descriptiveMetadata">
     <xsl:apply-templates select="*"/>
   </xsl:template>            

   <xsl:template match="lido:objectClassificationWrap">
     <xsl:apply-templates select="lido:classificationWrap/lido:classification"/>
   </xsl:template>            

   <xsl:template match="lido:classification[lido:conceptID][@lido:type='nominal']">
     <xsl:for-each select="lido:conceptID">
       <nmo:Denomination rdf:resource="{.}"/>
     </xsl:for-each> 
   </xsl:template>            

   <xsl:template match="*"/>

</xsl:stylesheet>
