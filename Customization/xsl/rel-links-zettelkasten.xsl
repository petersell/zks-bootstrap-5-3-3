<?xml version="1.0" encoding="UTF-8" ?>
<!--
This file is part of the DITA Open Toolkit project.

Copyright 2004, 2005 IBM Corporation

See the accompanying LICENSE file for applicable license.
-->
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
                xmlns:related-links="http://dita-ot.sourceforge.net/ns/200709/related-links"
                xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
                exclude-result-prefixes="xs related-links ditamsg dita-ot">
  
  <!--main template for setting up all links after the body - applied to the related-links container-->
  <xsl:template match="*[contains(@class, ' topic/related-links ')]" name="topic.related-links">
    <nav xsl:use-attribute-sets="navigation">
      <xsl:call-template name="commonattributes"/>
      <xsl:if test="$include.roles = ('child', 'descendant')">
        <xsl:call-template name="ul-child-links"/>
        <!--handle child/descendants outside of linklists in collection-type=unordered or choice-->
        <xsl:call-template name="ol-child-links"/>
        <!--handle child/descendants outside of linklists in collection-type=ordered/sequence-->
      </xsl:if>
      <xsl:if test="$include.roles = ('next', 'previous', 'parent')">
        <xsl:call-template name="next-prev-parent-links"/>
        <!--handle next and previous links-->
      </xsl:if>
      <!-- Group all unordered links (which have not already been handled by prior sections). Skip duplicate links. -->
      <!-- NOTE: The actual grouping code for related-links:group-unordered-links is common between
             transform types, and is located in ../common/related-links.xsl. Actual code for
             creating group titles and formatting links is located in XSL files specific to each type. -->
      <xsl:variable name="unordered-links" as="element()*">
       <xsl:apply-templates select="." mode="related-links:group-unordered-links">
         <xsl:with-param name="nodes"
                         select="descendant::*[contains(@class, ' topic/link ')]
                                              [not(related-links:omit-from-unordered-links(.))]
                                              [generate-id(.) = generate-id(key('hideduplicates', related-links:hideduplicates(.))[1])]"/>
       </xsl:apply-templates>
      </xsl:variable>
      <xsl:apply-templates select="$unordered-links">
        <xsl:with-param name="root" select="root()" as="document-node()" tunnel="yes"/>
      </xsl:apply-templates>
      <!-- Diagonale START-->
      <xsl:value-of select="$newline"/>
      <!-- Diagonale END -->
      <!--linklists - last but not least, create all the linklists and their links, with no sorting or re-ordering-->
      <xsl:apply-templates select="*[contains(@class, ' topic/linklist ')]"/>
    </nav>
  </xsl:template>

</xsl:stylesheet>
