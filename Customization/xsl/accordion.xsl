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
  <!-- Customization to add Bootstrap Accordion Component -->
  <!-- https://getbootstrap.com/docs/5.3/components/accordion/ -->

  <xsl:template match="*[contains(@class,' topic/bodydiv ') and contains(@outputclass, 'accordion')]">
    <div>
      <xsl:attribute name="id" select="dita-ot:generate-html-id(.)"/>
      <xsl:call-template name="commonattributes"/>
      <xsl:apply-templates mode="accordion"/>
    </div>
  </xsl:template>

  <xsl:template name="expand-accordion-head">
    <xsl:attribute name="aria-expanded" select="contains(@outputclass,'show')"/>
    <xsl:attribute name="class">
      <xsl:choose>
        <xsl:when test="contains(@outputclass,'show')">
          <xsl:text>accordion-button</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>accordion-button collapsed</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <xsl:template name="expand-accordion-body">
    <xsl:attribute name="class">
      <xsl:text>accordion-collapse collapse</xsl:text>
      <xsl:if test="contains(@outputclass,'show')">
        <xsl:text> show</xsl:text>
      </xsl:if>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' topic/section ')]" mode="accordion">
    <xsl:param name="headLevel">
      <xsl:variable name="headCount" select="count(ancestor::*[contains(@class, ' topic/topic ')])+1"/>
      <xsl:choose>
        <xsl:when test="$headCount > 6">h6</xsl:when>
        <xsl:otherwise>h<xsl:value-of select="$headCount"/></xsl:otherwise>
      </xsl:choose>
    </xsl:param>

    <xsl:variable name="index" select="count(preceding-sibling::*[contains(@class, ' topic/section ')])"/>
    <xsl:variable name="id" select="dita-ot:generate-html-id(.)"/>
    <xsl:variable name="parent" select="dita-ot:generate-html-id(..)"/>

    <div class="accordion-item">
      <xsl:element name="{$headLevel}">
        <xsl:attribute name="type" select="'accordion-header'"/>
        <xsl:attribute name="id" select="concat('heading_' ,$id)"/>
        <button class="accordion-button" type="button" data-bs-toggle="collapse">
          <xsl:call-template name="expand-accordion-head"/>
          <xsl:attribute name="data-bs-target" select="concat('#collapse_' ,$id)"/>
          <xsl:attribute name="aria-controls" select="concat('collapse_' ,$id)"/>
          <xsl:value-of select="*[contains(@class, ' topic/title ')]"/>
        </button>
      </xsl:element>
      <div>
        <xsl:call-template name="expand-accordion-body"/>
        <xsl:attribute name="id" select="concat('collapse_' ,$id)"/>
        <xsl:attribute name="aria-labelledby" select="concat('heading_' ,$id)"/>
        <xsl:choose>
          <xsl:when test="contains(../@outputclass,'accordion-open')"/>
          <xsl:otherwise>
            <xsl:attribute name="data-bs-parent" select="concat('#', $parent)"/>
          </xsl:otherwise>
        </xsl:choose>
        <div class="accordion-body">
          <!--xsl:call-template name="commonattributes">
                <xsl:with-param name="default-output-class" select="'accordion-body'"/>
             </xsl:call-template-->
          <xsl:call-template name="gen-toc-id"/>
          <xsl:call-template name="setidaname"/>
          <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
          <xsl:apply-templates
            select="*[not(contains(@class, ' topic/title '))] | text() | comment() | processing-instruction()"
          />
          <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
        </div>
      </div>
    </div>
  </xsl:template>
</xsl:stylesheet>
