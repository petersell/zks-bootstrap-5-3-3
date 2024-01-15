<?xml version="1.0" encoding="UTF-8"?>
<!--
  This file is part of the DITA Bootstrap plug-in for DITA Open Toolkit.
  See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  version="2.0"
  exclude-result-prefixes="xs dita-ot"
>
  <xsl:param name="BOOTSTRAP_CSS_SHORTDESC" select="'text-body-secondary lead'"/>
  <xsl:param name="BOOTSTRAP_CSS_CODEBLOCK" select="'alert alert-secondary'"/>
  <xsl:param name="BOOTSTRAP_CSS_TOPIC_TITLE" select="''"/>
  <xsl:param name="BOOTSTRAP_CSS_SECTION_TITLE" select="'h4'"/>
  <xsl:param name="BOOTSTRAP_CSS_CARD" select="''"/>
  <xsl:param name="BOOTSTRAP_CSS_CAROUSEL" select="''"/>
  <xsl:param name="BOOTSTRAP_CSS_CAPTION" select="'alert alert-secondary p-1'"/>
  <xsl:param name="BOOTSTRAP_CSS_TABS" select="''"/>
  <xsl:param name="BOOTSTRAP_CSS_TABS_VERTICAL" select="'me-3'"/>
  <xsl:param name="BOOTSTRAP_CSS_ACCORDION" select="''"/>
  <xsl:param name="BOOTSTRAP_CSS_ACCESSIBILITY_NAV" select="'bg-body-tertiary'"/>
  <xsl:param name="BOOTSTRAP_CSS_ACCESSIBILITY_LINK" select="'btn btn-outline-primary btn-sm'"/>
  <xsl:param name="BOOTSTRAP_CSS_FIGURE" select="' w-100 mw-100 p-3 '"/>
  <xsl:param name="BOOTSTRAP_CSS_FIGURE_CAPTION" select="''"/>
  <xsl:param name="BOOTSTRAP_CSS_FIGURE_IMAGE" select="'img-fluid border rounded'"/>
  <xsl:param name="BOOTSTRAP_CSS_DL" select="'row'"/>
  <xsl:param name="BOOTSTRAP_CSS_DT" select="'text-truncate '"/>
  <xsl:param name="BOOTSTRAP_CSS_DD" select="''"/>
  <xsl:param name="BOOTSTRAP_CSS_PAGINATION" select="''"/>
  <xsl:param name="BOOTSTRAP_CSS_TABLE" select="''"/>
  <xsl:param name="BOOTSTRAP_CSS_TABLE_HEAD" select="''"/>

  <xsl:param name="BOOTSTRAP_ICON_TIP" select="'bi bi-lightbulb'"/>
  <xsl:param name="BOOTSTRAP_ICON_FASTPATH" select="'bi bi-shield-check'"/>
  <xsl:param name="BOOTSTRAP_ICON_REMEMBER" select="'bi bi-clipboard-check'"/>
  <xsl:param name="BOOTSTRAP_ICON_RESTRICTION" select="'bi bi-slash-circle'"/>
  <xsl:param name="BOOTSTRAP_ICON_IMPORTANT" select="'bi bi-exclamation-circle-fill'"/>
  <xsl:param name="BOOTSTRAP_ICON_ATTENTION" select="'bi bi-exclamation-triangle'"/>
  <xsl:param name="BOOTSTRAP_ICON_CAUTION" select="'bi bi-exclamation-triangle'"/>
  <xsl:param name="BOOTSTRAP_ICON_WARNING" select="'bi bi-exclamation-triangle'"/>
  <xsl:param name="BOOTSTRAP_ICON_TROUBLE" select="'bi bi-exclamation-triangle'"/>
  <xsl:param name="BOOTSTRAP_ICON_DANGER" select="'bi bi-exclamation-triangle'"/>
  <xsl:param name="BOOTSTRAP_ICON_NOTICE" select="'bi bi-info-circle-fill'"/>
  <xsl:param name="BOOTSTRAP_ICON_NOTE" select="'bi bi-pencil'"/>

  <!-- Add a Bootstrap CSS border to codeblocks -->
  <xsl:template match="*[contains(@class, ' topic/pre ')]" mode="get-output-class">
    <xsl:value-of select="$BOOTSTRAP_CSS_CODEBLOCK"/>
    <xsl:next-match/>
  </xsl:template>

  <!-- Add a Bootstrap CSS border to tables -->
  <xsl:template match="*[contains(@class, ' topic/table ')]" mode="get-output-class">
    <xsl:value-of select="$BOOTSTRAP_CSS_TABLE"/>
    <xsl:choose>
      <xsl:when test="@colsep='1' and @rowsep='1'"> table-bordered</xsl:when>
      <xsl:when test="@colsep='0' and @rowsep='0'"> table-borderless</xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
    <xsl:next-match/>
  </xsl:template>
  <!-- Enhance the default Bootstrap CSS text color of the table headers -->
  <xsl:template match="*[contains(@class, ' topic/thead ')]" mode="get-output-class">
    <xsl:value-of select="$BOOTSTRAP_CSS_TABLE_HEAD"/>
    <xsl:next-match/>
  </xsl:template>

  <!-- Enhance the short desc with a Bootstrap CSS lead class -->
  <xsl:template match="*[contains(@class, ' topic/shortdesc ')]" mode="get-output-class">
    <xsl:value-of select="$BOOTSTRAP_CSS_SHORTDESC"/>
    <xsl:next-match/>
  </xsl:template>

  <!-- Change the default Bootstrap CSS text color of the headers -->
  <xsl:template
    match="*[contains(@class, ' topic/topic ')]/*[contains(@class, ' topic/title ')]"
    mode="get-output-class"
  >
    <xsl:value-of select="$BOOTSTRAP_CSS_TOPIC_TITLE"/>
    <xsl:next-match/>
  </xsl:template>

  <xsl:template
    match="*[contains(@class, ' topic/section ')]/*[contains(@class, ' topic/title ')]"
    mode="get-output-class"
  >
    <xsl:choose>
      <xsl:when test="contains(@outputclass, 'h1')"/>
      <xsl:when test="contains(@outputclass, 'h2')"/>
      <xsl:when test="contains(@outputclass, 'h3')"/>
      <xsl:when test="contains(@outputclass, 'h4')"/>
      <xsl:when test="contains(@outputclass, 'h5')"/>
      <xsl:when test="contains(@outputclass, 'h6')"/>
      <xsl:when test="contains(@outputclass, 'display-')"/>
      <xsl:otherwise>
        <xsl:value-of select="$BOOTSTRAP_CSS_SECTION_TITLE"/>
        <xsl:text> </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Change the default Bootstrap CSS classes of cards -->
  <xsl:template
    match="*[contains(@class,' topic/section ') and contains(@outputclass, 'card')]"
    mode="get-output-class"
  >
    <xsl:value-of select="$BOOTSTRAP_CSS_CARD"/>
    <xsl:next-match/>
  </xsl:template>

  <!-- Change the default Bootstrap CSS classes of carousel -->
  <xsl:template
    match="*[ (contains(@class,' topic/ul ') or contains(@class, ' topic/ol ')) and contains(@outputclass, 'carousel')]"
    mode="get-output-class"
  >
    <xsl:text>slide </xsl:text>
    <xsl:value-of select="$BOOTSTRAP_CSS_CAROUSEL"/>
    <xsl:next-match/>
  </xsl:template>

  <!-- Amend the text and background of Figure Captions -->
  <xsl:template
    match="*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/title ')]"
    mode="get-output-class"
    priority="5"
  >
    <xsl:value-of select="$BOOTSTRAP_CSS_CAPTION"/>
    <xsl:next-match/>
  </xsl:template>

  <!-- Change the default Bootstrap CSS classes of tabs -->
  <xsl:template
    match="*[contains(@class,' topic/bodydiv ') and contains(@outputclass, 'nav-tabs')]"
    mode="get-output-class"
  >
    <xsl:text>nav </xsl:text>
    <xsl:value-of select="$BOOTSTRAP_CSS_TABS"/>
    <xsl:next-match/>
  </xsl:template>
  <!-- Change the default Bootstrap CSS classes of tab pills -->
  <xsl:template
    match="*[contains(@class,' topic/bodydiv ') and contains(@outputclass, 'nav-pills')]"
    mode="get-output-class"
  >
    <xsl:text>nav </xsl:text>
    <xsl:choose>
      <xsl:when test="contains(@outputclass, 'nav-pills-vertical')">
        <xsl:text>flex-column nav-pills </xsl:text>
        <xsl:value-of select="$BOOTSTRAP_CSS_TABS_VERTICAL"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$BOOTSTRAP_CSS_TABS"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:next-match/>
  </xsl:template>

  <!-- Change the default Bootstrap CSS classes of accordion -->
  <xsl:template
    match="*[contains(@class,' topic/bodydiv ') and contains(@outputclass, 'accordion')]"
    mode="get-output-class"
  >
    <xsl:value-of select="BOOTSTRAP_CSS_ACCORDION"/>
    <xsl:next-match/>
  </xsl:template>

  <!-- Change the default Bootstrap CSS text color of the figure captions -->
  <xsl:template match="*[contains(@class, ' topic/figcaption ')]" mode="get-output-class">
    <xsl:text>figure-caption </xsl:text>
    <xsl:value-of select="$BOOTSTRAP_CSS_FIGURE_CAPTION"/>
    <xsl:next-match/>
  </xsl:template>

  <!-- Change the default Bootstrap CSS classes of pagination -->
  <xsl:template
    match="*[(contains(@class, ' topic/ol ') or contains(@class, ' topic/ul ')) and contains(@outputclass, 'pagination')]"
    mode="get-output-class"
  >
    <xsl:value-of select="$BOOTSTRAP_CSS_PAGINATION"/>
    <xsl:next-match/>
  </xsl:template>

  <xsl:template
    match="*[contains(@class,' topic/section ') and contains(@outputclass, 'pagination')]/*[(contains(@class, ' topic/ol ') or contains(@class, ' topic/ul '))]"
    mode="get-output-class"
  >
    <xsl:if test="ancestor::*[contains(@outputclass, 'pagination-')]">
      <xsl:text>pagination </xsl:text>
    </xsl:if>
    <xsl:value-of select="ancestor::*[contains(@outputclass, 'pagination')][1]/@outputclass"/>
    <xsl:value-of select="concat(' ', $BOOTSTRAP_CSS_PAGINATION)"/>
    <xsl:next-match/>
  </xsl:template>

  <!-- Add additional Bootstrap CSS classes based on outputclass -->
  <xsl:template name="bootstrap-class">
    <xsl:apply-templates select="." mode="bootstrap-class"/>
    <xsl:apply-templates select="." mode="gen-user-bootstrap-class"/>
  </xsl:template>

  <xsl:template match="/|node()|@*" mode="gen-user-bootstrap-class" priority="-10"/>

  <xsl:template match="/ | @* | node()" mode="bootstrap-class">
    <xsl:choose>
      <xsl:when test="contains(@outputclass, 'btn-group-vertical')">
        <xsl:text/>
      </xsl:when>
      <xsl:when test="contains(@outputclass, 'btn-group')">
        <xsl:text/>
      </xsl:when>
      <xsl:when test="contains(@outputclass, 'btn-toolbar')">
        <xsl:text/>
      </xsl:when>
      <xsl:when test="contains(@outputclass, 'accordion-')">
        <xsl:text>accordion</xsl:text>
      </xsl:when>
      <xsl:when test="contains(@outputclass, 'btn-')">
        <xsl:text>btn</xsl:text>
      </xsl:when>
      <xsl:when test="contains(@outputclass, 'collapse-')">
        <xsl:text>collapse</xsl:text>
      </xsl:when>
      <xsl:when test="contains(@class, ' topic/ph ') and contains(@outputclass, 'bg-')">
        <xsl:text>badge</xsl:text>
      </xsl:when>
      <xsl:when test="contains(@outputclass, 'alert-')">
        <xsl:text>alert</xsl:text>
      </xsl:when>
      <xsl:when test="contains(@outputclass, 'list-group-')">
        <xsl:text>list-group</xsl:text>
      </xsl:when>
      <xsl:when test="contains(@class, ' topic/fig ')">
        <xsl:text> figure </xsl:text>
        <xsl:value-of select="$BOOTSTRAP_CSS_FIGURE"/>
      </xsl:when>
      <xsl:when test="contains(@class, ' topic/lq ')">
        <xsl:text> blockquote </xsl:text>
      </xsl:when>
      <xsl:when test="contains(@class, ' topic/dl ')">
        <xsl:value-of select="$BOOTSTRAP_CSS_DL"/>
      </xsl:when>
      <xsl:when test="contains(@class, ' topic/dt ')">
        <xsl:if test="empty(@outputclass)">
          <xsl:call-template name="bootstrap-dt"/>
        </xsl:if>
        <xsl:value-of select="$BOOTSTRAP_CSS_DT"/>
      </xsl:when>
      <xsl:when test="contains(@class, ' topic/dd ')">
        <xsl:if test="empty(@outputclass)">
          <xsl:call-template name="bootstrap-dd"/>
        </xsl:if>
        <xsl:value-of select="$BOOTSTRAP_CSS_DD"/>
      </xsl:when>
      <xsl:when test="contains(@class, ' topic/image ') and ancestor::*[contains(@class, ' topic/fig ')]">
        <xsl:text> figure-img </xsl:text>
        <xsl:value-of select="$BOOTSTRAP_CSS_FIGURE_IMAGE"/>
      </xsl:when>
      <xsl:when test="contains(@outputclass, 'carousel-')">
        <xsl:text>carousel</xsl:text>
      </xsl:when>
      <xsl:when test="contains(@class, ' topic/title ') and ancestor::*[contains(@outputclass, 'alert-')]">
        <xsl:text>alert-heading</xsl:text>
      </xsl:when>
      <xsl:when test="contains(@class, ' topic/xref ') and ancestor::*[contains(@outputclass, 'alert-')]">
        <xsl:text>alert-link</xsl:text>
      </xsl:when>
      <xsl:when
        test="contains(@class, ' topic/li ') and (ancestor::ul[contains(@outputclass, 'list-group')] or ancestor::ol[contains(@outputclass, 'list-group')])"
      >
        <xsl:text>list-group-item</xsl:text>
      </xsl:when>
      <xsl:when
        test="contains(@class, ' topic/li ') and (ancestor::ul[contains(@outputclass, 'list-inline')] or ancestor::ol[contains(@outputclass, 'list-inline')])"
      >
        <xsl:text>list-inline-item</xsl:text>
      </xsl:when>
      <xsl:when test="contains(@outputclass, 'pagination-')">
        <xsl:text>pagination</xsl:text>
      </xsl:when>
      <xsl:when test="contains(@class, ' topic/li ') and ancestor::*[contains(@outputclass, 'pagination')]">
        <xsl:text>page-item</xsl:text>
      </xsl:when>
      <xsl:when test="contains(@class, ' topic/xref ') and ancestor::*[contains(@outputclass, 'pagination')]">
        <xsl:text>page-link</xsl:text>
      </xsl:when>
      <xsl:when test="$BOOTSTRAP_ICONS_INCLUDE = 'yes'">
        <xsl:choose>
          <xsl:when test="contains(@class,' hi-d/i ') and contains(@outputclass, 'bi-')">
            <xsl:text>bi</xsl:text>
          </xsl:when>
          <xsl:when
            test="contains(@class, ' topic/xref ') and .//*[contains(@class,' hi-d/i ') and contains(@outputclass, 'bi-')]"
          >
            <xsl:text>icon-link</xsl:text>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
    <xsl:if test="@scalefit='yes'">
      <xsl:text> img-fluid</xsl:text>
    </xsl:if>
    <xsl:text> </xsl:text>
  </xsl:template>

  <!-- Add additional Bootstrap CSS classes and roles to <dd> elements -->
  <xsl:template name="bootstrap-dd">
    <xsl:variable name="terms" select="count(../*[contains(@class, ' topic/dt ')])"/>
    <xsl:variable name="is-first-dd" select="empty(preceding-sibling::*[contains(@class, ' topic/dd ')])"/>
    <xsl:choose>
      <xsl:when test="not($is-first-dd)">
        <xsl:text>col-lg-12  </xsl:text>
      </xsl:when>
      <xsl:when test="$terms=1">
        <xsl:text>col-lg-9 </xsl:text>
      </xsl:when>
      <xsl:when test="$terms=2">
        <xsl:text>col-lg-6 </xsl:text>
      </xsl:when>
      <xsl:when test="$terms=3">
        <xsl:text>col-lg-3 </xsl:text>
      </xsl:when>
      <xsl:when test="$terms=4">
        <xsl:text>col-lg-2 </xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- Add additional Bootstrap CSS classes and roles to <dt> elements -->
  <xsl:template name="bootstrap-dt">
    <xsl:variable name="terms" select="count(../*[contains(@class, ' topic/dt ')])"/>
    <xsl:choose>
      <xsl:when test="$terms=1">
        <xsl:text>col-lg-3 </xsl:text>
      </xsl:when>
      <xsl:when test="$terms=2">
        <xsl:text>col-lg-3 </xsl:text>
      </xsl:when>
      <xsl:when test="$terms=3">
        <xsl:text>col-lg-3 </xsl:text>
      </xsl:when>
      <xsl:when test="$terms=4">
        <xsl:text>col-lg-2 </xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- Add additional Bootstrap CSS classes and roles to <note> elements -->
  <xsl:template name="bootstrap-note">
    <xsl:text>alert </xsl:text>
    <xsl:choose>
      <xsl:when test="@type='tip'">
        <xsl:text>alert-success</xsl:text>
      </xsl:when>
      <xsl:when test="@type='fastpath'">
        <xsl:text>alert-success</xsl:text>
      </xsl:when>
      <xsl:when test="@type='remember'">
        <xsl:text>alert-success</xsl:text>
      </xsl:when>
      <xsl:when test="@type='restriction'">
        <xsl:text>alert-warning</xsl:text>
      </xsl:when>
      <xsl:when test="@type='important'">
        <xsl:text>alert-warning</xsl:text>
      </xsl:when>
      <xsl:when test="@type='attention'">
        <xsl:text>alert-warning</xsl:text>
      </xsl:when>
      <xsl:when test="@type='caution'">
        <xsl:text>alert-warning</xsl:text>
      </xsl:when>
      <xsl:when test="@type='warning'">
        <xsl:text>alert-warning</xsl:text>
      </xsl:when>
      <xsl:when test="@type='trouble'">
        <xsl:text>alert-warning</xsl:text>
      </xsl:when>
      <xsl:when test="@type='danger'">
        <xsl:text>alert-danger</xsl:text>
      </xsl:when>
      <xsl:when test="@type='notice'">
        <xsl:text>alert-info</xsl:text>
      </xsl:when>
      <xsl:when test="@type='note'">
        <xsl:text>alert-info</xsl:text>
      </xsl:when>
      <xsl:when test="@type='other'">
        <xsl:text>alert-dark</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>alert-info</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Add style to a bootstrap element based on otherprops -->
  <xsl:template name="otherprops-attributes">
    <xsl:apply-templates select="." mode="otherprops-attributes"/>
  </xsl:template>

  <xsl:template match="/ | @* | node()" mode="otherprops-attributes">
    <xsl:analyze-string select="@otherprops" regex="[A-Za-z0-9_\-]*\([^\)]*\)">
      <xsl:matching-substring>
        <xsl:variable name="var">
          <xsl:value-of select="."/>
        </xsl:variable>
        <xsl:variable name="attr">
          <xsl:value-of select="substring-before($var, '(')"/>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$attr='icon'">
            <xsl:attribute name="class" select="concat('pe-2 ', substring-before(substring-after($var, '('),')'))"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="{$attr}" select="substring-before(substring-after($var, '('),')')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:matching-substring>
    </xsl:analyze-string>
  </xsl:template>

  <!-- Add icons to <note> elements -->
  <xsl:template name="bootstrap-icon">
    <xsl:variable name="icon">
      <xsl:choose>
        <xsl:when test="@type='tip'">
          <xsl:value-of select="$BOOTSTRAP_ICON_TIP"/>
        </xsl:when>
        <xsl:when test="@type='fastpath'">
          <xsl:value-of select="$BOOTSTRAP_ICON_FASTPATH"/>
        </xsl:when>
        <xsl:when test="@type='remember'">
          <xsl:value-of select="$BOOTSTRAP_ICON_REMEMBER"/>
        </xsl:when>
        <xsl:when test="@type='restriction'">
          <xsl:value-of select="$BOOTSTRAP_ICON_RESTRICTION"/>
        </xsl:when>
        <xsl:when test="@type='important'">
          <xsl:value-of select="$BOOTSTRAP_ICON_IMPORTANT"/>
        </xsl:when>
        <xsl:when test="@type='attention'">
          <xsl:value-of select="$BOOTSTRAP_ICON_ATTENTION"/>
        </xsl:when>
        <xsl:when test="@type='caution'">
          <xsl:value-of select="$BOOTSTRAP_ICON_CAUTION"/>
        </xsl:when>
        <xsl:when test="@type='warning'">
          <xsl:value-of select="$BOOTSTRAP_ICON_WARNING"/>
        </xsl:when>
        <xsl:when test="@type='trouble'">
          <xsl:value-of select="$BOOTSTRAP_ICON_TROUBLE"/>
        </xsl:when>
        <xsl:when test="@type='danger'">
          <xsl:value-of select="$BOOTSTRAP_ICON_DANGER"/>
        </xsl:when>
        <xsl:when test="@type='notice'">
          <xsl:value-of select="$BOOTSTRAP_ICON_NOTICE"/>
        </xsl:when>
        <xsl:when test="@type='note'">
          <xsl:value-of select="$BOOTSTRAP_ICON_NOTE"/>
        </xsl:when>
        <!--xsl:when test="@type='other'"/-->
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="contains(@otherprops, 'icon(')">
        <xsl:element name="i">
          <xsl:call-template name="otherprops-attributes"/>
        </xsl:element>
      </xsl:when>
      <xsl:when test="$icon != ''">
        <xsl:element name="i">
          <xsl:attribute name="class" select="concat('pe-2 ', $icon)"/>
          <xsl:if test="contains(@otherprops, 'style(')">
            <xsl:call-template name="otherprops-attributes"/>
          </xsl:if>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- add role attributes based on outputclass -->
  <xsl:template name="bootstrap-role">
    <xsl:choose>
      <xsl:when test="contains(@outputclass, 'alert-')">
        <xsl:attribute name="role" select="'alert'"/>
      </xsl:when>
      <xsl:when test="contains(@outputclass, 'btn-group-vertical')">
        <xsl:attribute name="role" select="'group'"/>
      </xsl:when>
      <xsl:when test="contains(@outputclass, 'btn-group')">
        <xsl:attribute name="role" select="'group'"/>
      </xsl:when>
      <xsl:when test="contains(@outputclass, 'btn-toolbar')">
        <xsl:attribute name="role" select="'toolbar'"/>
      </xsl:when>
      <xsl:when test="contains(@outputclass, 'btn-')">
        <xsl:attribute name="role" select="'button'"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
