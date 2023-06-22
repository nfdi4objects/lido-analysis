<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.lido-schema.org"
    xmlns:lido="http://www.lido-schema.org"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:nmo="http://nomisma.org/ontology#"
xmlns:oai="http://www.openarchives.org/OAI/2.0/">
  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="/">
    <rdf:RDF>
      <xsl:apply-templates select="*/lido:lido"/>
    </rdf:RDF>
  </xsl:template>

  <xsl:template match="lido:lido">
    <rdf:Description>
       <xsl:attribute name="rdf:about">
          <xsl:value-of select="lido:objectPublishedID"/>
       </xsl:attribute>
       <xsl:apply-templates select="*"/>
    </rdf:Description>
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
