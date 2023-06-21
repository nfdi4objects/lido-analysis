<?xml version="1.0" encoding="UTF-8"?>
<!-- Extract OAI metadata records from OAI-PMH responses -->
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:oai="http://www.openarchives.org/OAI/2.0/" exclude-result-prefixes="oai">
  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="/Response">
    <records>
      <xsl:apply-templates select="ListRecords/oai:record"/>
    </records>
  </xsl:template>

  <xsl:template match="/Records">
    <records>
      <xsl:apply-templates select="oai:record"/>
    </records>
  </xsl:template>

  <xsl:template match="oai:record">
      <xsl:copy-of select="oai:metadata/*"/>
  </xsl:template>
</xsl:transform>  

