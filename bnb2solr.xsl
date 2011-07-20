<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:isbd="http://iflastandards.info/ns/isbd/elements/"
  xmlns:owlt="http://www.w3.org/2006/time#"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#">
<xsl:output indent="yes" method="text"/>

<xsl:variable name="vB1">\\</xsl:variable>
<xsl:variable name="vB2">\\\\</xsl:variable>

<xsl:variable name="vQ1">"</xsl:variable>
<xsl:variable name="vQ2">\\"</xsl:variable>

<xsl:template match="/">
  <xsl:text>[&#xa;</xsl:text>
  <xsl:for-each select="rdf:RDF/rdf:Description">
    <xsl:text>{</xsl:text>
    <xsl:text>"id":"</xsl:text>
    <xsl:value-of select="dcterms:identifier[1]"/>
    <xsl:text>",</xsl:text>
    
    <xsl:for-each select="child::*">
      <xsl:if test="name(.) != 'dcterms:title'
                and name(.) != 'dcterms:type'
                and name(.) != 'dcterms:publisher'
                and name(.) != 'dcterms:issued'
                and name(.) != 'dcterms:language'
                and name(.) != 'dcterms:extent'
                and name(.) != 'dcterms:tableOfContents'
                and name(.) != 'dcterms:contributor'
                and name(.) != 'isbd:hasPlaceOfPublicationProductionDistribution'
                and name(.) != 'dc:date'
                and name(.) != 'dcterms:description'
                and name(.) != 'dcterms:subject'
                and name(.) != 'dcterms:isPartOf'
                and name(.) != 'dcterms:identifier'
                and name(.) != 'dcterms:relation'
                and name(.) != 'dcterms:coverage'
                and name(.) != 'isbd:hasEditionStatement'
                and name(.) != 'isbd:hasNoteOnLanguage'
                and name(.) != 'dcterms:alternative'
                and name(.) != 'dcterms:audience'
                and name(.) != 'dcterms:accessRights'
                and name(.) != 'dcterms:replaces'
                and name(.) != 'dcterms:abstract'
                and name(.) != 'dcterms:requires'
                and name(.) != 'dcterms:isReplacedBy'
                and name(.) != 'dcterms:hasFormat'
                and name(.) != 'dcterms:dateCopyrighted'
                and name(.) != 'dcterms:isReferencedBy'
                and name(.) != 'dcterms:created'
      ">
        <xsl:message>Unknown FIELD: [<xsl:value-of select="name(.)"/>]   <xsl:copy-of select="."/>  </xsl:message>
      </xsl:if>
        
        <xsl:if test="name(.) = 'dcterms:language'">
          <xsl:choose>
            <xsl:when test="not(rdf:Description) or not(rdf:Description/rdf:value)">
              <xsl:message>ERROR: <xsl:value-of select="../dcterms:identifier[1]"/> dcterms:language <xsl:copy-of select="."/></xsl:message>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="insert">
                <xsl:with-param name="key"><xsl:value-of select="local-name(.)"/></xsl:with-param>
                <xsl:with-param name="value"><xsl:value-of select="rdf:Description/rdf:value"/></xsl:with-param>
              </xsl:call-template>
              <xsl:if test="position() != last()">,</xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>

        <xsl:if test="name(.) = 'dc:date'">
          <xsl:choose>
            <xsl:when test="not(owlt:Interval)
                         or not(owlt:Interval/owlt:hasBeginning)
                         or not(owlt:Interval/owlt:hasBeginning/owlt:Instant)
                         or not(owlt:Interval/owlt:hasBeginning/owlt:Instant/owlt:inXSDDateTime)
                         or not(owlt:Interval/owlt:hasEnd)
                         or not(owlt:Interval/owlt:hasEnd/owlt:Instant)
                         or not(owlt:Interval/owlt:hasEnd/owlt:Instant/owlt:inXSDDateTime)
              ">
              <xsl:message>ERROR: <xsl:value-of select="../dcterms:identifier[1]"/> dc:date <xsl:copy-of select="."/></xsl:message>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="insert">
                <xsl:with-param name="key">date_beginning</xsl:with-param>
                <xsl:with-param name="value"><xsl:value-of select="owlt:Interval/owlt:hasBeginning/owlt:Instant/owlt:inXSDDateTime"/></xsl:with-param>
              </xsl:call-template>
              <xsl:text>,</xsl:text>
              <xsl:call-template name="insert">
                <xsl:with-param name="key">date_end</xsl:with-param>
                <xsl:with-param name="value"><xsl:value-of select="owlt:Interval/owlt:hasEnd/owlt:Instant/owlt:inXSDDateTime"/></xsl:with-param>
              </xsl:call-template>
              <xsl:if test="position() != last()">,</xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>

        <xsl:if test="name(.) = 'dcterms:subject'">
          <xsl:choose>
            <xsl:when test="skos:Concept">
              <xsl:choose>
                <xsl:when test="skos:Concept/skos:notation">
                  <xsl:choose>
                    <xsl:when test="skos:Concept/skos:notation[@rdf:datatype = 'ddc:Notation']">
                      <xsl:call-template name="insert">
                        <xsl:with-param name="key">subject_ddc</xsl:with-param>
                        <xsl:with-param name="value"><xsl:value-of select="skos:Concept/skos:notation"/></xsl:with-param>
                      </xsl:call-template>
                      <xsl:if test="position() != last()">,</xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:message>ERROR: <xsl:value-of select="../dcterms:identifier[1]"/> dcterms:subject#2 <xsl:copy-of select="."/></xsl:message>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:when test="skos:Concept/skos:prefLabel
                            and skos:Concept/skos:inScheme[@rdf:resource='http://id.loc.gov/authorities#conceptScheme']
                ">
                  <xsl:call-template name="insert">
                    <xsl:with-param name="key">subject_lcsh</xsl:with-param>
                    <xsl:with-param name="value"><xsl:value-of select="skos:Concept/skos:prefLabel"/></xsl:with-param>
                  </xsl:call-template>
                  <xsl:if test="position() != last()">,</xsl:if>
                </xsl:when>
                <xsl:when test="skos:Concept/skos:prefLabel">
                  <xsl:call-template name="insert">
                    <xsl:with-param name="key"><xsl:value-of select="local-name(.)"/></xsl:with-param>
                    <xsl:with-param name="value"><xsl:value-of select="skos:Concept/skos:prefLabel"/></xsl:with-param>
                  </xsl:call-template>
                  <xsl:if test="position() != last()">,</xsl:if>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:message>ERROR: <xsl:value-of select="../dcterms:identifier[1]"/> dcterms:subject#3 <xsl:copy-of select="."/></xsl:message>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="rdf:Description/rdfs:label">
              <xsl:call-template name="insert">
                <xsl:with-param name="key"><xsl:value-of select="local-name(.)"/></xsl:with-param>
                <xsl:with-param name="value"><xsl:value-of select="rdf:Description/rdfs:label"/></xsl:with-param>
              </xsl:call-template>
              <xsl:if test="position() != last()">,</xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:message>ERROR: <xsl:value-of select="../dcterms:identifier[1]"/> dcterms:subject#1 <xsl:copy-of select="."/></xsl:message>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>

        <xsl:if test="name(.) = 'dcterms:coverage'">
          <xsl:choose>
            <xsl:when test="skos:Concept">
              <xsl:choose>
                <xsl:when test="skos:Concept/skos:prefLabel
                            and skos:Concept/skos:inScheme[@rdf:resource='http://id.loc.gov/authorities#conceptScheme']">
                  <xsl:call-template name="insert">
                    <xsl:with-param name="key">coverage_lcsh</xsl:with-param>
                    <xsl:with-param name="value"><xsl:value-of select="rdf:Description/rdfs:label"/></xsl:with-param>
                  </xsl:call-template>
                  <xsl:if test="position() != last()">,</xsl:if>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:message>ERROR: <xsl:value-of select="../dcterms:identifier[1]"/> dcterms:coverage#2 <xsl:copy-of select="."/></xsl:message>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:message>ERROR: <xsl:value-of select="../dcterms:identifier[1]"/> dcterms:coverage#1 <xsl:copy-of select="."/></xsl:message>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>

        <xsl:if test="name(.) = 'dcterms:extent'
                   or name(.) = 'dcterms:publisher'
                   or name(.) = 'dcterms:contributor'
                   or name(.) = 'isbd:hasPlaceOfPublicationProductionDistribution'
                   or name(.) = 'dcterms:isPartOf'
                   or name(.) = 'dcterms:relation'
                   or name(.) = 'dcterms:type'
                   or name(.) = 'dcterms:audience'
                   or name(.) = 'dcterms:accessRights'
                   or name(.) = 'dcterms:replaces'
                   or name(.) = 'dcterms:requires'
                   or name(.) = 'dcterms:isReplacedBy'
                   or name(.) = 'dcterms:hasFormat'
                   or name(.) = 'dcterms:isReferencedBy'
          ">
          <xsl:choose>
            <xsl:when test="rdf:Description and rdf:Description/rdfs:label">
              <xsl:call-template name="insert">
                <xsl:with-param name="key"><xsl:value-of select="local-name(.)"/></xsl:with-param>
                <xsl:with-param name="value"><xsl:value-of select="rdf:Description/rdfs:label"/></xsl:with-param>
              </xsl:call-template>
              <xsl:if test="position() != last()">,</xsl:if>
            </xsl:when>
            <xsl:when test="rdf:description and rdf:description/rdfs:label">
              <xsl:call-template name="insert">
                <xsl:with-param name="key"><xsl:value-of select="local-name(.)"/></xsl:with-param>
                <xsl:with-param name="value"><xsl:value-of select="rdf:description/rdfs:label"/></xsl:with-param>
              </xsl:call-template>
              <xsl:if test="position() != last()">,</xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:message>ERROR: <xsl:value-of select="../dcterms:identifier[1]"/> <xsl:value-of select="name(.)"/> <xsl:copy-of select="."/></xsl:message>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>

        <xsl:if test="name(.) = 'dcterms:title' 
                   or name(.) = 'dcterms:issued' 
                   or name(.) = 'dcterms:tableOfContents'
                   or name(.) = 'dcterms:description'
                   or name(.) = 'dcterms:identifier'
                   or name(.) = 'isbd:hasEditionStatement'
                   or name(.) = 'isbd:hasNoteOnLanguage'
                   or name(.) = 'dcterms:alternative'
                   or name(.) = 'dcterms:abstract'
                   or name(.) = 'dcterms:dateCopyrighted'
                   or name(.) = 'dcterms:created'
          ">
          <xsl:choose>
            <xsl:when test="count(child::*)">
              <xsl:message>ERROR: <xsl:value-of select="../dcterms:identifier[1]"/> <xsl:value-of select="name(.)"/> <xsl:copy-of select="."/></xsl:message>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="insert">
                <xsl:with-param name="key"><xsl:value-of select="local-name(.)"/></xsl:with-param>
                <xsl:with-param name="value"><xsl:value-of select="."/></xsl:with-param>
              </xsl:call-template>
              <xsl:if test="position() != last()">,</xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
        
      </xsl:for-each>
    <xsl:text>}</xsl:text>
    <xsl:if test="position() != last()">,</xsl:if>
    <xsl:text>&#xa;</xsl:text>
  </xsl:for-each>
  <xsl:text>]</xsl:text>
</xsl:template>

<xsl:template name="insert">
  <xsl:param name="key" />
  <xsl:param name="value" />
  
  <xsl:value-of select="concat($vQ1, $key, '_txt', $vQ1, ':')"/>
  <xsl:value-of select="concat($vQ1, replace(replace($value, $vB1, $vB2), $vQ1, $vQ2), $vQ1)"/>
</xsl:template>

</xsl:stylesheet>
<!-- java -Xms500M -Xmx3024M -jar /path/to/download/saxonica/saxon9he.jar -t -s:test.xml -xsl:/path/to/bnb.xsl -->
