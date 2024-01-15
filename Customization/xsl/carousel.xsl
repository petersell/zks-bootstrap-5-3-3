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
  <!-- Customization to add Bootstrap Carousel Component -->
  <!-- https://getbootstrap.com/docs/5.3/components/carousel/ -->

  <xsl:param name="BOOTSTRAP_CSS_CAROUSEL_INDICATORS" select="'btn btn-primary bg-primary btn-sm'"/>

  <xsl:template name="carousel-previous-next">
    <xsl:param name="id"/>
    <a class="carousel-control-prev" role="button" data-bs-slide="prev">
      <xsl:attribute name="data-bs-target" select="concat('#' , $id)"/>
      <xsl:call-template name="color-control">
        <xsl:with-param name="icon" select="'carousel-control-prev-icon'"/>
      </xsl:call-template>
      <span class="visually-hidden">
        <xsl:call-template name="getVariable">
          <xsl:with-param name="id" select="'Previous'"/>
        </xsl:call-template>
      </span>
    </a>
    <a class="carousel-control-next" role="button" data-bs-slide="next">
      <xsl:attribute name="data-bs-target" select="concat('#' , $id)"/>
      <xsl:call-template name="color-control">
        <xsl:with-param name="icon" select="'carousel-control-next-icon'"/>
      </xsl:call-template>
      <span class="visually-hidden">
        <xsl:call-template name="getVariable">
          <xsl:with-param name="id" select="'Next'"/>
        </xsl:call-template>
      </span>
    </a>
  </xsl:template>

  <xsl:template name="carousel-indicators">
    <xsl:param name="id"/>
    <div class="carousel-indicators">
      <xsl:for-each select="*[contains(@class, ' topic/li ')]">
        <button type="button">
          <xsl:attribute name="class">
            <xsl:value-of select="$BOOTSTRAP_CSS_CAROUSEL_INDICATORS"/>
            <xsl:if test="count(preceding-sibling::*[contains(@class, ' topic/li ')]) = 0">
              <xsl:text> active</xsl:text>
            </xsl:if>
          </xsl:attribute>
          <xsl:if test="count(preceding-sibling::*[contains(@class, ' topic/li ')]) = 0">
            <xsl:attribute name="aria-current" select="'true'"/>
          </xsl:if>
          <xsl:attribute name="data-bs-target" select="concat('#', $id)"/>
          <xsl:attribute name="data-bs-slide-to" select="count(preceding-sibling::*[contains(@class, ' topic/li ')])"/>
        </button>
      </xsl:for-each>
    </div>
  </xsl:template>

  <xsl:template
    match="*[ (contains(@class,' topic/ul ') or contains(@class, ' topic/ol ')) and contains(@outputclass, 'carousel')]"
  >
    <xsl:variable name="id">
      <xsl:value-of select="concat('carousel_' ,dita-ot:generate-html-id(.))"/>
    </xsl:variable>
    <div>
      <xsl:choose>
        <xsl:when test="contains(@otherprops, 'autoplay(false)')">
          <xsl:attribute name="data-bs-ride" select="'true'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="data-bs-ride" select="'carousel'"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="contains(@otherprops, 'touch(false)')">
        <xsl:attribute name="data-bs-touch" select="'false'"/>
      </xsl:if>
      <xsl:attribute name="id" select="$id"/>
      <xsl:call-template name="commonattributes"/>
      <xsl:if test="contains(@otherprops, 'indicators(true)')">
        <xsl:call-template name="carousel-indicators">
          <xsl:with-param name="id" select="$id"/>
        </xsl:call-template>
      </xsl:if>
      <div class="carousel-inner pb-1">
        <xsl:apply-templates mode="carousel"/>
      </div>
      <xsl:call-template name="carousel-previous-next">
        <xsl:with-param name="id" select="$id"/>
      </xsl:call-template>
    </div>
  </xsl:template>

  <!-- Carousel Items, Slides only -->
  <xsl:template match="*[contains(@class,' topic/li ')]" mode="carousel">
    <div>
      <xsl:call-template name="commonattributes">
        <xsl:with-param name="default-output-class">
          <xsl:text>carousel-item</xsl:text>
          <xsl:if test="count(preceding-sibling::*[contains(@class, ' topic/li ')]) = 0">
            <xsl:text> active</xsl:text>
          </xsl:if>
        </xsl:with-param>
      </xsl:call-template>
      <xsl:if test="contains(@otherprops, 'interval(')">
        <xsl:call-template name="otherprops-interval"/>
      </xsl:if>
      <div class="container mx-0">
        <div class="row">
          <xsl:apply-templates select="*[contains(@class,' topic/fig ')]" mode="carousel"/>
          <xsl:apply-templates select="*[contains(@class,' topic/image ')]" mode="carousel"/>
        </div>
        <xsl:apply-templates select="*[contains(@class,' topic/div ')]" mode="carousel"/>
        <xsl:if test="../../*[contains(@otherprops, 'indicators(true)')]">
          <div class="row py-3"/>
        </xsl:if>
      </div>
      <xsl:apply-templates
        select="*[contains(@class,' topic/fig ')]/*[contains(@class, ' topic/title ')]"
        mode="carousel"
      />
    </div>
  </xsl:template>

  <!-- Carousel Items Slides with Captions -->
  <xsl:template match="*[contains(@class,' topic/fig ')]" mode="carousel">
    <xsl:apply-templates select="*[contains(@class,' topic/image ')]" mode="carousel"/>
  </xsl:template>

  <xsl:template name="color-control">
    <xsl:param name="icon"/>
    <xsl:choose>
      <xsl:when test="contains(@outputclass, 'carousel-fade')"/>
      <xsl:otherwise>
        <span class="btn btn-primary btn-sm p-0">
          <span aria-hidden="true">
            <xsl:attribute name="class" select="concat($icon, ' align-middle')"/>
          </span>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*[contains(@class,' topic/image ')]" mode="carousel">
    <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
    <xsl:variable name="images" select="count(../*[contains(@class, ' topic/image ')])"/>
    <xsl:variable name="imageWidth">
      <xsl:choose>
        <xsl:when test="$images=1">
          <xsl:text>col-12</xsl:text>
        </xsl:when>
        <xsl:when test="$images=2">
          <xsl:text>col-6</xsl:text>
        </xsl:when>
        <xsl:when test="$images=3">
          <xsl:text>col-4</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>col-3</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <div>
      <xsl:attribute name="class" select="$imageWidth"/>
      <img>
        <xsl:call-template name="commonattributes">
          <xsl:with-param name="default-output-class" select="'d-block w-100'"/>
        </xsl:call-template>
        <xsl:call-template name="setid"/>
        <xsl:choose>
          <xsl:when test="*[contains(@class, ' topic/longdescref ')]">
            <xsl:apply-templates select="*[contains(@class, ' topic/longdescref ')]"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="@longdescref"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="@href|@height|@width"/>
        <xsl:apply-templates select="@scale"/>
        <xsl:choose>
          <xsl:when test="*[contains(@class, ' topic/alt ')]">
            <xsl:variable name="alt-content">
              <xsl:apply-templates select="*[contains(@class, ' topic/alt ')]" mode="text-only"/>
            </xsl:variable>
            <xsl:attribute name="alt" select="normalize-space($alt-content)"/>
          </xsl:when>
          <xsl:when test="@alt">
            <xsl:attribute name="alt" select="@alt"/>
          </xsl:when>
        </xsl:choose>
      </img>
    </div>
    <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
  </xsl:template>

  <!-- Slide Caption -->
  <xsl:template match="*[contains(@class,' topic/title ')]" mode="carousel">
    <div class="carousel-caption d-none d-md-block">
      <p>
        <xsl:call-template name="commonattributes"/>
        <xsl:apply-templates/>
      </p>
    </div>
  </xsl:template>

  <xsl:template match="*[contains(@class,' topic/div ')]" mode="carousel">
    <div class="row">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template name="otherprops-interval">
    <xsl:analyze-string select="@otherprops" regex="[a-z]*\([^\)]*\)">
      <xsl:matching-substring>
        <xsl:variable name="var">
          <xsl:value-of select="."/>
        </xsl:variable>
        <xsl:variable name="attr">
          <xsl:value-of select="substring-before($var, '(')"/>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$attr='interval'">
            <xsl:attribute name="data-bs-interval" select="substring-before(substring-after($var, '('),')')"/>
          </xsl:when>
        </xsl:choose>
      </xsl:matching-substring>
    </xsl:analyze-string>
  </xsl:template>
</xsl:stylesheet>
