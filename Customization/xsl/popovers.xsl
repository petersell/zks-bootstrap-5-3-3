<?xml version="1.0" encoding="UTF-8"?>
<!--
  This file is part of the DITA Bootstrap plug-in for DITA Open Toolkit.
  See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  version="2.0"
  exclude-result-prefixes="xs xhtml dita-ot"
>
  <!-- Customization to add Bootstrap Popover component -->
  <!-- https://getbootstrap.com/docs/5.3/components/popovers/ -->

  <xsl:template match="*" mode="add-bootstrap-popover">
    <xsl:attribute name="data-bs-toggle">
      <xsl:text>popover</xsl:text>
    </xsl:attribute>
    <xsl:attribute name="data-bs-placement">
      <xsl:choose>
        <xsl:when test="contains(@outputclass, 'popover-left')">
          <xsl:text>left</xsl:text>
        </xsl:when>
        <xsl:when test="contains(@outputclass, 'popover-right')">
          <xsl:text>right</xsl:text>
        </xsl:when>
        <xsl:when test="contains(@outputclass, 'popover-bottom')">
          <xsl:text>bottom</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>top</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:if test="*[contains(@class, ' topic/data ') and contains(@name, 'title')][1]">
      <xsl:attribute name="title">
        <xsl:value-of select="*[contains(@class, ' topic/data ') and contains(@name, 'title')][1]"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="*[contains(@class, ' topic/data ') and contains(@name, 'class')][1]">
      <xsl:attribute name="data-bs-custom-class">
        <xsl:value-of select="*[contains(@class, ' topic/data ') and contains(@name, 'class')][1]"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:attribute name="data-bs-content">
      <xsl:value-of select="*[contains(@class, ' topic/desc ')][1]"/>
    </xsl:attribute>
  </xsl:template>

  <!--template for xref-->
  <xsl:template match="*[contains(@class, ' topic/xref ') and contains(@outputclass, 'popover-')]">
    <a>
      <!-- ↓ Add Bootstrap class attributes template ↑ -->
      <xsl:apply-templates select="." mode="add-bootstrap-popover"/>
      <xsl:call-template name="commonattributes"/>
      <xsl:apply-templates
        select="*[not(contains(@class, ' topic/desc '))] | text() | comment() | processing-instruction()"
      />
    </a>
  </xsl:template>
</xsl:stylesheet>
