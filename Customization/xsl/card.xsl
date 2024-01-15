<?xml version="1.0" encoding="utf-8"?>
<!--
  This file is part of the DITA Bootstrap plug-in for DITA Open Toolkit.
  See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet
  version="2.0"
  exclude-result-prefixes="xs xhtml dita-ot"
  xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>
  <!-- Customization to add Bootstrap Card Component -->
  <!-- https://getbootstrap.com/docs/5.3/components/card/ -->

  <xsl:template match="*[contains(@class,' topic/section ') and contains(@outputclass, 'card')]">
    <div>
      <xsl:call-template name="commonattributes"/>
      <xsl:call-template name="setid"/>
      <xsl:apply-templates
        select="*[contains(@class, ' topic/sectiondiv ') and contains(@outputclass, 'card-header')]"
      />
      <xsl:apply-templates select="*[contains(@outputclass, 'card-img-top')]"/>
      <div class="card-body">
        <xsl:apply-templates select="*[contains(@class, ' topic/title ')]" mode="card"/>
        <xsl:apply-templates
          select="*[not(contains(@class, ' topic/title '))  and not(contains(@outputclass, 'card-img-top')) and not(contains(@outputclass, 'card-img-bottom'))  and not(contains(@outputclass, 'card-header'))  and not(contains(@outputclass, 'card-footer'))    ]"
        />
      </div>
      <xsl:apply-templates select="*[contains(@outputclass, 'card-img-bottom')]"/>
      <xsl:apply-templates
        select="*[contains(@class, ' topic/sectiondiv ') and contains(@outputclass, 'card-footer')]"
      />
    </div>
  </xsl:template>

  <!-- Card Body -->
  <xsl:template match="*" mode="card">
    <xsl:param name="headLevel">
      <xsl:variable name="headCount" select="count(ancestor::*[contains(@class, ' topic/topic ')])+1"/>
      <xsl:choose>
        <xsl:when test="$headCount > 6">h6</xsl:when>
        <xsl:when test="count(preceding-sibling::*[contains(@class, ' topic/title ')]) > 0">h<xsl:value-of
            select="$headCount+1"
          /></xsl:when>
        <xsl:otherwise>h<xsl:value-of select="$headCount"/></xsl:otherwise>
      </xsl:choose>
    </xsl:param>

    <xsl:variable name="bootstrap-class">
      <xsl:choose>
        <xsl:when
          test="count(preceding-sibling::*[contains(@class, ' topic/title ')]) > 0"
        >sectiontitle card-subtitle text-body-secondary</xsl:when>
        <xsl:otherwise>sectiontitle card-title</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:element name="{$headLevel}">
      <xsl:attribute name="class">
        <xsl:value-of select="$bootstrap-class"/>
      </xsl:attribute>
      <xsl:call-template name="commonattributes">
        <xsl:with-param name="default-output-class" select="$bootstrap-class"/>
      </xsl:call-template>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
