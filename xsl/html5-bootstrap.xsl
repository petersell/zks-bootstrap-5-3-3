<?xml version="1.0" encoding="UTF-8"?>
<!-- Copyright © 2017 · infotexture · Roger W. Fienhold Sheen -->
<!-- See the accompanying LICENSE file for applicable license -->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
  version="2.0"
  exclude-result-prefixes="xs dita-ot"
>
  <!-- the file name containing XHTML to be placed in the HEAD area
       (file name and extension only - no path). -->
  <xsl:param name="BOOTSTRAP_ICONS_CDN"/>
  <!-- Whether to include bootstrap icons.  values are 'yes' or 'no' -->
  <xsl:param name="BOOTSTRAP_ICONS_INCLUDE" select="'yes'"/>
  <!-- Whether include a subheader menu bar.  values are 'yes' or 'no' -->
  <xsl:param name="BOOTSTRAP_MENUBAR_TOC" select="'no'"/>
  <!-- Whether to include bootstrap popovers.  values are 'yes' or 'no' -->
  <xsl:param name="BOOTSTRAP_DARK_MODE_INCLUDE" select="'yes'"/>
  <!-- Whether to include dark mode toggling.  values are 'yes' or 'no' -->
  <xsl:param name="BOOTSTRAP_POPOVERS_INCLUDE" select="'yes'"/>
  <!-- Whether to include a scrollspy Toc -->
  <xsl:param name="BOOTSTRAP_SCROLLSPY_TOC" select="'none'"/>

  <xsl:import href="plugin:org.dita.html5:xsl/dita2html5.xsl"/>

  <xsl:include href="../Customization/xsl/accordion.xsl"/>
  <xsl:include href="../Customization/xsl/breadcrumb.xsl"/>
  <xsl:include href="../Customization/xsl/card.xsl"/>
  <xsl:include href="../Customization/xsl/carousel.xsl"/>
  <xsl:include href="../Customization/xsl/collapse.xsl"/>
  <xsl:include href="../Customization/xsl/hi-d.xsl"/>
  <xsl:include href="../Customization/xsl/nav.xsl"/>
  <xsl:include href="../Customization/xsl/offcanvas.xsl"/>
  <xsl:include href="../Customization/xsl/pagination.xsl"/>
  <xsl:include href="../Customization/xsl/popovers.xsl"/>
  <xsl:include href="../Customization/xsl/scrollspy.xsl"/>
  <xsl:include href="../Customization/xsl/tables.xsl"/>
  <xsl:include href="../Customization/xsl/tabs.xsl"/>
  <xsl:include href="../Customization/xsl/tooltips.xsl"/>
  <xsl:include href="../Customization/xsl/topic.xsl"/>
  <xsl:include href="../Customization/xsl/utility-classes.xsl"/>

  <!-- Override to add <meta> elements to page heads -->
  <xsl:template match="*" mode="chapterHead">
    <head>
      <!-- initial meta information -->
      <xsl:call-template name="generateCharset"/>   <!-- Set the character set to UTF-8 -->
      <!-- ↓ Add <meta> element from Bootstrap starter template ↓ -->
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
      <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
      <xsl:call-template name="generateDefaultCopyright"/> <!-- Generate a default copyright, if needed -->
      <xsl:call-template name="generateDefaultMeta"/> <!-- Standard meta for security, robots, etc -->
      <xsl:call-template name="getMeta"/>           <!-- Process metadata from topic prolog -->
      <xsl:call-template name="copyright"/>         <!-- Generate copyright, if specified manually -->
      <xsl:call-template name="generateChapterTitle"/> <!-- Generate the <title> element -->
      <xsl:call-template name="gen-user-head"/>    <!-- include user's XSL HEAD processing here -->
      <xsl:call-template name="gen-user-scripts"/> <!-- include user's XSL javascripts here -->
      <xsl:call-template name="processHDF"/>        <!-- Add user HDF file, if specified -->
      <xsl:call-template name="generateCssLinks"/>  <!-- Generate links to CSS files -->
      <xsl:call-template name="gen-user-styles"/>   <!-- include user's XSL style element and content here -->

      <!-- Add Bootstrap icons -->
      <xsl:if test="$BOOTSTRAP_ICONS_INCLUDE = 'yes'">
        <!--Check the file Url Definition of HDF HDR FTR-->
        <xsl:variable name="BOOTSTRAP_CDNFILE">
          <xsl:choose>
            <xsl:when test="not($BOOTSTRAP_ICONS_CDN)"/> <!-- If no filterfile leave empty -->
            <xsl:when test="starts-with($BOOTSTRAP_ICONS_CDN, 'file:')">
              <xsl:value-of select="$BOOTSTRAP_ICONS_CDN"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="starts-with($BOOTSTRAP_ICONS_CDN, '/')">
                  <xsl:text>file://</xsl:text><xsl:value-of select="$BOOTSTRAP_ICONS_CDN"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>file:/</xsl:text><xsl:value-of select="$BOOTSTRAP_ICONS_CDN"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:if test="string-length($BOOTSTRAP_CDNFILE) > 0">
          <xsl:copy-of select="document($BOOTSTRAP_CDNFILE, /)"/>
        </xsl:if>
      </xsl:if>
    </head>
  </xsl:template>

  <!-- Override to use a CSS Grid -->
  <xsl:template match="*" mode="chapterBody">
    <body>
      <xsl:apply-templates select="." mode="addAttributesToHtmlBodyElement"/>
      <xsl:call-template name="setaname"/>  <!-- For HTML4 compatibility, if needed -->

      <xsl:call-template name="gen-skip-to-main"/>
      <!-- ↓ Add CSS classes to use a CSS Grid - see side-toc.css for details  -->
      <xsl:apply-templates select="." mode="addHeaderToHtmlBodyElement"/>
      <xsl:if test="$BOOTSTRAP_MENUBAR_TOC = 'yes'">
        <xsl:apply-templates select="." mode="gen-user-toptoc"/>
      </xsl:if>

      <div class="bs-container container-xxl bd-gutter mt-3 my-md-4" id="content">
        <xsl:call-template name="gen-user-sidetoc"/>
        <xsl:apply-templates select="." mode="addContentToHtmlBodyElement"/>
      </div>

      <xsl:variable name="relpath">
        <xsl:choose>
          <xsl:when test="$FILEDIR='.'">
            <xsl:text>.</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="replace(replace($FILEDIR, '\\', '/') ,'[^/]+','..')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:if test="$BOOTSTRAP_POPOVERS_INCLUDE = 'yes'">
        <script language="javascript" src="{$relpath}/js/popovers.js"/>
      </xsl:if>
      <xsl:if test="$BOOTSTRAP_DARK_MODE_INCLUDE = 'yes'">
        <script language="javascript" src="{$relpath}/js/dark-mode-toggler.js"/>
      </xsl:if>
      <!-- ↑ End customization -->
      <xsl:apply-templates select="." mode="addFooterToHtmlBodyElement"/>
    </body>
  </xsl:template>

  <!-- Hidden accessibility buttons for screen readers and keyboard navigation-->
  <xsl:template name="gen-skip-to-main">
    <div>
      <xsl:attribute
        name="class"
        select="concat('visually-hidden-focusable overflow-hidden p-2 ', $BOOTSTRAP_CSS_ACCESSIBILITY_NAV)"
      />

      <div class="container-xl">
        <a>
          <xsl:attribute name="class" select="concat('d-inline-flex m-1 ', $BOOTSTRAP_CSS_ACCESSIBILITY_LINK)"/>
          <xsl:apply-templates mode="scrollspy-href" select="*[contains(@class, ' topic/title ')][1]"/>
          <xsl:call-template name="getVariable">
            <xsl:with-param name="id" select="'Skip to main content'"/>
          </xsl:call-template>
        </a>
        <xsl:choose>
          <xsl:when test="$BOOTSTRAP_MENUBAR_TOC = 'yes'">
            <!-- "skip to docs" link refers to the menubar -->
            <a href="#bs-menubar-nav">
              <xsl:attribute
                name="class"
                select="concat('d-none d-md-inline-flex m-1 ', $BOOTSTRAP_CSS_ACCESSIBILITY_LINK)"
              />
              <xsl:call-template name="getVariable">
                <xsl:with-param name="id" select="'Skip to docs navigation'"/>
              </xsl:call-template>
            </a>
          </xsl:when>
          <xsl:when test="$nav-toc = 'none'">
            <!-- do not add a "skip to docs" link -->
          </xsl:when>
          <xsl:otherwise>
            <!-- Add a "skip to docs" link to the sidebar -->
            <a href="#bs-sidebar-nav">
              <xsl:attribute
                name="class"
                select="concat('d-none d-md-inline-flex m-1 ', $BOOTSTRAP_CSS_ACCESSIBILITY_LINK)"
              />
              <xsl:call-template name="getVariable">
                <xsl:with-param name="id" select="'Skip to docs navigation'"/>
              </xsl:call-template>
            </a>
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </div>
  </xsl:template>

  <!-- Override to add scrollspy -->
  <xsl:template match="*" mode="addAttributesToBody">
    <xsl:if test="$BOOTSTRAP_SCROLLSPY_TOC != 'none'">
      <xsl:attribute name="data-bs-spy">scroll</xsl:attribute>
      <xsl:attribute name="data-bs-target">#bs-scrollspy</xsl:attribute>
    </xsl:if>
  </xsl:template>

  <!--
    Overrides to add CSS classes to use a CSS Grid for the navigation layout
  -->
  <xsl:attribute-set name="main">
    <xsl:attribute name="class">bs-main me-3</xsl:attribute>
    <xsl:attribute name="role">main</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="toc">
    <xsl:attribute name="role">navigation</xsl:attribute>
    <xsl:attribute name="id">bs-sidebar-nav</xsl:attribute>
    <xsl:attribute name="class">d-flex flex-align-start flex-column h-100 overflow-y-auto</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="menubar-toc">
    <xsl:attribute name="class">navbar bg-body-tertiary px-3 border-0</xsl:attribute>
    <xsl:attribute name="role">navigation</xsl:attribute>
    <xsl:attribute name="id">bs-menubar-nav</xsl:attribute>
  </xsl:attribute-set>
</xsl:stylesheet>
