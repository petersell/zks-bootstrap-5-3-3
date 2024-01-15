<?xml version="1.0" encoding="UTF-8"?>
<!--
  This file is part of the DITA Bootstrap plug-in for DITA Open Toolkit.
  See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
  xmlns:dita2html="http://dita-ot.sourceforge.net/ns/200801/dita2html"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  version="2.0"
  exclude-result-prefixes="xs dita-ot dita2html"
>
  <xsl:param name="defaultLanguage" select="'en'" as="xs:string"/>
  <xsl:param name="BIDIRECTIONAL_DOCUMENT" select="'no'" as="xs:string"/>
  <xsl:param name="BOOTSTRAP_CSS_FOOTER" select="'mt-3 border-top bg-primary-subtle'"/>
  <xsl:param name="BOOTSTRAP_TOPBAR_HDR"/>


  <!--Check the file Url Definition of the TOP HDR FTR-->
  <xsl:variable name="TOPHDFFILE">
    <xsl:choose>
     <xsl:when test="not($BOOTSTRAP_TOPBAR_HDR)"/> <!-- If no filterfile leave empty -->
     <xsl:when test="starts-with($BOOTSTRAP_TOPBAR_HDR, 'file:')">
       <xsl:value-of select="$BOOTSTRAP_TOPBAR_HDR"/>
     </xsl:when>
     <xsl:otherwise>
       <xsl:choose>
         <xsl:when test="starts-with($BOOTSTRAP_TOPBAR_HDR, '/')">
           <xsl:text>file://</xsl:text><xsl:value-of select="$BOOTSTRAP_TOPBAR_HDR"/>
         </xsl:when>
         <xsl:otherwise>
           <xsl:text>file:/</xsl:text><xsl:value-of select="$BOOTSTRAP_TOPBAR_HDR"/>
         </xsl:otherwise>
       </xsl:choose>
     </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>


  <xsl:variable name="defaultDirection">
    <xsl:apply-templates select="." mode="get-render-direction">
      <xsl:with-param name="lang" select="$defaultLanguage"/>
    </xsl:apply-templates>
  </xsl:variable>

  <!-- Define a newline character -->
  <xsl:variable name="newline">
<xsl:text>
</xsl:text>
  </xsl:variable>

  <xsl:template name="bidi-auto-code">
    <!-- ↓ Ensure code is rendered LTR in RTL documents ↓ -->
    <xsl:if test="$BIDIRECTIONAL_DOCUMENT='yes' and not(@dir)">
      <xsl:choose>
        <xsl:when test="contains(@class,' pr-d/')">
          <xsl:attribute name="dir">auto</xsl:attribute>
        </xsl:when>
        <xsl:when test="contains(@class,' sw-d/')">
          <xsl:attribute name="dir">auto</xsl:attribute>
        </xsl:when>
        <xsl:when test="contains(@class,' xml-d/')">
          <xsl:attribute name="dir">auto</xsl:attribute>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <!-- Customized templates from `org.dita.html5/xsl/topic.xsl` -->

  <xsl:template name="chapter-setup">
    <html>
      <!-- ↓ Add check for bi-directional content ↓ -->
      <xsl:if test="$BIDIRECTIONAL_DOCUMENT = 'no'">
        <xsl:call-template name="setTopicLanguage"/>
      </xsl:if>
      <xsl:if test="$BIDIRECTIONAL_DOCUMENT = 'yes'">
        <xsl:attribute name="dir" select="$defaultDirection"/>
        <xsl:attribute name="lang" select="$defaultLanguage"/>
      </xsl:if>
      <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
      <xsl:call-template name="chapterHead"/>
      <xsl:call-template name="chapterBody"/>
    </html>
  </xsl:template>

  <!-- Process <body> content that is appropriate for HTML5 header section. -->
  <xsl:template match="*" mode="addHeaderToHtmlBodyElement">
    <xsl:variable name="header-content" as="node()*">
      <xsl:call-template name="generateBreadcrumbs"/>
      <xsl:call-template name="gen-user-header"/>  <!-- include user's XSL running header here -->
      <xsl:call-template name="processHDR"/>
      <xsl:if test="$INDEXSHOW = 'yes'">
        <xsl:apply-templates
          select="/*/*[contains(@class, ' topic/prolog ')]/*[contains(@class, ' topic/metadata ')]/*[contains(@class, ' topic/keywords ')]/*[contains(@class, ' topic/indexterm ')] |
                                     /dita/*[1]/*[contains(@class, ' topic/prolog ')]/*[contains(@class, ' topic/metadata ')]/*[contains(@class, ' topic/keywords ')]/*[contains(@class, ' topic/indexterm ')]"
        />
      </xsl:if>
    </xsl:variable>

    <!-- ↓ Add collapsible top header ↓ -->
    <xsl:if test="string-length($TOPHDFFILE) > 0">
      <div class="d-none d-lg-block">
        <xsl:copy-of select="document($TOPHDFFILE, /)"/>
      </div>
    </xsl:if>
    <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->

    <xsl:if test="exists($header-content)">
      <header xsl:use-attribute-sets="banner">
        <!-- ↓ Add Bootstrap class attributes template ↓ -->
        <xsl:attribute name="class">
          <xsl:text>sticky-top</xsl:text>
          <xsl:if test="$BOOTSTRAP_MENUBAR_TOC = 'yes'">
            <xsl:text> bg-body-tertiary</xsl:text>
          </xsl:if>
        </xsl:attribute>
        <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
        <xsl:sequence select="$header-content"/>
      </header>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*" mode="addContentToHtmlBodyElement">
    <main xsl:use-attribute-sets="main">
      <article role="article" class="bs-content">
        <!-- ↓ Add check for bi-directional content ↓ -->
        <xsl:if test="$BIDIRECTIONAL_DOCUMENT = 'yes'">
          <xsl:variable name="direction">
            <xsl:apply-templates select="." mode="get-render-direction">
              <xsl:with-param name="lang" select="dita-ot:get-current-language(.)"/>
            </xsl:apply-templates>
          </xsl:variable>
          <xsl:attribute name="dir" select="$direction"/>
          <xsl:attribute name="lang" select="dita-ot:get-current-language(.)"/>
        </xsl:if>
        <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
        <xsl:attribute name="aria-labelledby">
          <xsl:apply-templates
            select="*[contains(@class,' topic/title ')] |
                                       self::dita/*[1]/*[contains(@class,' topic/title ')]"
            mode="return-aria-label-id"
          />
        </xsl:attribute>
        <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
        <!-- ↓ Add Bootstrap breadcrumb ↓ -->
        <xsl:if test="$BREADCRUMBS = 'yes'">
          <xsl:apply-templates select="$current-topicref" mode="gen-user-breadcrumb"/>
        </xsl:if>
        <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
        <xsl:apply-templates/> <!-- this will include all things within topic; therefore, -->
                               <!-- title content will appear here by fall-through -->
                               <!-- followed by prolog (but no fall-through is permitted for it) -->
                               <!-- followed by body content, again by fall-through in document order -->
                               <!-- followed by related links -->
                               <!-- followed by child topics by fall-through -->
        <xsl:call-template name="gen-endnotes"/>    <!-- include footnote-endnotes -->
        <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
      </article>
      <xsl:if test="$BOOTSTRAP_SCROLLSPY_TOC != 'none'">
        <xsl:if test="count(*[contains(@class, ' topic/topic ')])&gt;0">
          <div class="bs-scrollspy mt-3 mb-5 my-lg-0 mb-lg-5 px-sm-1 text-body-secondary">
            <xsl:call-template name="scrollspy-content"/>
          </div>
        </xsl:if>
      </xsl:if>
    </main>
  </xsl:template>

  <!-- Override to add Bootstrap classes and roles -->
  <xsl:template match="@* | node()" mode="commonattributes">
    <xsl:param name="default-output-class" as="xs:string*"/>
    <xsl:apply-templates select="@xml:lang"/>
    <xsl:apply-templates select="@dir"/>
    <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/@style" mode="add-ditaval-style"/>
    <!-- ↓ Add Bootstrap role template ↓ -->
    <xsl:call-template name="bootstrap-role"/>
    <!-- ↓ Set Bidi to auto for code ↓ -->
    <xsl:call-template name="bidi-auto-code"/>
    <!-- ↓ Add Bootstrap class attributes template ↓ -->
    <xsl:variable name="bootstrap-class">
      <xsl:call-template name="bootstrap-class"/>
      <xsl:value-of select="$default-output-class"/>
    </xsl:variable>
    <!-- ↓ Remove DITA-OT styling from titles since Bootstrap does this ↓ -->
    <xsl:choose>
      <xsl:when test="starts-with($default-output-class[1] , 'topictitle')">
        <xsl:apply-templates select="." mode="set-output-class">
          <xsl:with-param name="default" select="replace($bootstrap-class, 'topictitle\d+', '')"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="starts-with($default-output-class[1] , 'sectiontitle')">
        <xsl:apply-templates select="." mode="set-output-class">
          <xsl:with-param name="default" select="replace($bootstrap-class, 'sectiontitle', '')"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="set-output-class">
          <xsl:with-param name="default" select="$bootstrap-class"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="gen-user-bootstrap-attrs"/>
    <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
    <xsl:choose>
      <xsl:when test="exists($passthrough-attrs[empty(@att) and empty(@value)])">
        <xsl:variable name="specializations" as="xs:string*">
          <xsl:for-each select="ancestor-or-self::*[@domains][1]/@domains">
            <xsl:analyze-string select="normalize-space(.)" regex="a\(props (.+?)\)">
              <xsl:matching-substring>
                <xsl:sequence select="tokenize(regex-group(1), '\s+')"/>
              </xsl:matching-substring>
            </xsl:analyze-string>
          </xsl:for-each>
        </xsl:variable>
        <xsl:for-each
          select="@props |
                              @audience |
                              @platform |
                              @product |
                              @otherprops |
                              @deliveryTarget |
                              @*[local-name() = $specializations]"
        >
          <xsl:attribute name="data-{name()}" select="."/>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="exists($passthrough-attrs)">
        <xsl:for-each select="@*">
          <xsl:if
            test="$passthrough-attrs[@att = name(current()) and (empty(@val) or (some $v in tokenize(current(), '\s+') satisfies $v = @val))]"
          >
            <xsl:attribute name="data-{name()}" select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="gen-user-bootstrap-attrs">
    <xsl:apply-templates select="." mode="gen-user-bootstrap-attrs"/>
  </xsl:template>

  <xsl:template match="/ | @* | node()" mode="gen-user-bootstrap-attrs" priority="-10"/>

  <!-- Override to add Bootstrap Alert classes and roles to Note elements -->
  <!-- https://getbootstrap.com/docs/5.3/components/alerts/ -->
  <xsl:template match="*" mode="process.note.common-processing">
    <xsl:param name="type" select="@type"/>
    <xsl:param name="title">
      <xsl:call-template name="getVariable">
        <xsl:with-param name="id" select="concat(upper-case(substring($type, 1, 1)), substring($type, 2))"/>
      </xsl:call-template>
    </xsl:param>
    <!-- ↓ Add Bootstrap class attributes template ↓ -->
    <xsl:variable name="bootstrap-class">
      <xsl:if test="not(contains(@outputclass, 'alert-'))">
        <xsl:call-template name="bootstrap-note"/>
      </xsl:if>
    </xsl:variable>
    <div role="alert">
      <xsl:call-template name="commonattributes">
        <xsl:with-param name="default-output-class" select="$bootstrap-class"/>
        <!--xsl:with-param name="default-output-class" select="string-join(($type, concat('note_', $type)), ' ')"/-->
      </xsl:call-template>
      <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
      <xsl:call-template name="setidaname"/>
      <!-- Normal flags go before the generated title; revision flags only go on the content. -->
      <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/prop" mode="ditaval-outputflag"/>
      <span class="note__title">
        <!-- ↓ Add Bootstrap icon ↓ -->
        <xsl:if test="$BOOTSTRAP_ICONS_INCLUDE = 'yes'">
          <xsl:call-template name="bootstrap-icon"/>
        </xsl:if>
        <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
        <xsl:copy-of select="$title"/>
        <xsl:call-template name="getVariable">
          <xsl:with-param name="id" select="'ColonSymbol'"/>
        </xsl:call-template>
      </span>
      <xsl:text> </xsl:text>
      <xsl:apply-templates
        select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/revprop"
        mode="ditaval-outputflag"
      />
      <xsl:apply-templates/>
      <!-- Normal end flags and revision end flags both go out after the content. -->
      <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
    </div>
  </xsl:template>

  <!-- Customization to add Bootstrap Figure Content -->
  <!-- https://getbootstrap.com/docs/5.3/content/figures/ -->
  <xsl:template
    match="*[contains(@class, ' topic/fig ') and not(contains(@class,' pr-d/syntaxdiagram ')) and not(contains(@class,' ut-d/imagemap '))]"
    name="topic.fig"
  >
    <xsl:variable name="default-fig-class">
      <xsl:apply-templates select="." mode="dita2html:get-default-fig-class"/>
    </xsl:variable>
    <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
    <figure>
      <xsl:if test="$default-fig-class != ''">
        <xsl:attribute name="class" select="$default-fig-class"/>
      </xsl:if>
      <xsl:call-template name="commonattributes">
        <xsl:with-param name="default-output-class" select="$default-fig-class"/>
      </xsl:call-template>
      <xsl:call-template name="setscale"/>
      <xsl:call-template name="setidaname"/>
      <!--xsl:call-template name="place-fig-lbl"/-->
      <xsl:apply-templates
        select="node() except *[contains(@class, ' topic/title ') or contains(@class, ' topic/desc ')]"
      />
      <!-- ↓ Move Figure title below image ↓ -->
      <xsl:call-template name="place-fig-lbl"/>
      <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
    </figure>
    <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
    <xsl:value-of select="$newline"/>
  </xsl:template>

  <!-- Figure caption -->
  <xsl:template name="place-fig-lbl">
    <xsl:param name="stringName"/>
    <!-- Number of fig/title's including this one -->
    <xsl:variable
      name="fig-count-actual"
      select="count(preceding::*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/title ')])+1"
    />
    <xsl:variable name="ancestorlang">
      <xsl:call-template name="getLowerCaseLang"/>
    </xsl:variable>
    <xsl:choose>
      <!-- title -or- title & desc -->
      <xsl:when test="*[contains(@class, ' topic/title ')]">
        <figcaption>
          <!-- ↓ Add Bootstrap figure caption class ↓ -->
          <xsl:variable name="fig-caption-class">
            <xsl:choose>
              <xsl:when test="*[contains(@class, ' topic/lq ')]">
                <xsl:value-of select="concat('blockquote-footer ', $BOOTSTRAP_CSS_FIGURE_CAPTION)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat('figure-caption ', $BOOTSTRAP_CSS_FIGURE_CAPTION)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:apply-templates select="." mode="set-output-class">
            <xsl:with-param
              name="default"
              select="concat($fig-caption-class, ./*[contains(@class, ' topic/title ')][1]/@outputclass)"
            />
          </xsl:apply-templates>
          <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
          <span class="fig--title-label">
            <xsl:choose>
              <!-- Blockquote - figure -->
              <xsl:when test="*[contains(@class, ' topic/lq ')]">
              </xsl:when>
              <!-- Hungarian: "1. Figure " -->
              <xsl:when test="$ancestorlang = ('hu', 'hu-hu')">
                <xsl:value-of select="$fig-count-actual"/>
                <xsl:text>. </xsl:text>
                <xsl:call-template name="getVariable">
                  <xsl:with-param name="id" select="'Figure'"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="getVariable">
                  <xsl:with-param name="id" select="'Figure'"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$fig-count-actual"/>
                <xsl:text>. </xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </span>
          <xsl:apply-templates select="*[contains(@class, ' topic/title ')]" mode="figtitle"/>
          <xsl:if test="*[contains(@class, ' topic/desc ')]">
            <xsl:text>. </xsl:text>
          </xsl:if>
          <xsl:for-each select="*[contains(@class, ' topic/desc ')]">
            <span class="figdesc">
              <xsl:call-template name="commonattributes"/>
              <xsl:apply-templates select="." mode="figdesc"/>
            </span>
          </xsl:for-each>
        </figcaption>
      </xsl:when>
      <!-- desc -->
      <xsl:when test="*[contains(@class, ' topic/desc ')]">
        <xsl:for-each select="*[contains(@class, ' topic/desc ')]">
          <figcaption>
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates select="." mode="figdesc"/>
          </figcaption>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- Customization to add Bootstrap Borders to Codeblock elements-->
  <!-- https://getbootstrap.com/docs/5.3/utilities/borders/ -->
  <xsl:template match="*[contains(@class, ' topic/pre ') and @frame]">
    <xsl:variable name="default-fig-class">
      <xsl:apply-templates select="." mode="dita2html:get-default-fig-class"/>
    </xsl:variable>
    <figure>
      <xsl:if test="$default-fig-class != ''">
        <xsl:attribute name="class">
          <xsl:value-of select="$default-fig-class"/>
          <xsl:text> figure </xsl:text>
          <xsl:value-of select="$BOOTSTRAP_CSS_FIGURE"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
      <xsl:call-template name="spec-title-nospace"/>
      <pre>
        <xsl:attribute name="class" select="name()"/>
        <xsl:call-template name="commonattributes"/>
        <xsl:call-template name="setscale"/>
        <xsl:call-template name="setidaname"/>
        <xsl:apply-templates/>
      </pre>
      <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
    </figure>
  </xsl:template>

  <!-- Customization to add Bootstrap Borders to Lines elements-->
  <!-- https://getbootstrap.com/docs/5.3/utilities/borders/ -->
  <xsl:template match="*[contains(@class, ' topic/lines ') and @frame]">
    <xsl:variable name="default-fig-class">
      <xsl:apply-templates select="." mode="dita2html:get-default-fig-class"/>
    </xsl:variable>
    <figure>
      <xsl:if test="$default-fig-class != ''">
        <xsl:attribute name="class">
          <xsl:value-of select="$default-fig-class"/>
          <xsl:text> figure </xsl:text>
          <xsl:value-of select="$BOOTSTRAP_CSS_FIGURE"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:call-template name="spec-title-nospace"/>
      <p>
        <xsl:call-template name="commonattributes"/>
        <xsl:call-template name="setscale"/>
        <xsl:call-template name="setidaname"/>
        <xsl:apply-templates/>
      </p>
    </figure>
  </xsl:template>

  <!-- Determine the default Bootstrap class attribute for a figure -->
  <xsl:template match="*" mode="dita2html:get-default-fig-class">
    <xsl:choose>
      <xsl:when test="@frame = 'all'">border</xsl:when>
      <xsl:when test="@frame = 'sides'">border-start border-end</xsl:when>
      <xsl:when test="@frame = 'top'">border-top</xsl:when>
      <xsl:when test="@frame = 'bottom'">border-bottom</xsl:when>
      <xsl:when test="@frame = 'topbot'">border-top border-bottom</xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>

  <xsl:template
    match="*[contains(@class, ' topic/ph ') and contains(@otherprops, 'title(')  and (contains(@outputclass, 'initialism') or contains(@outputclass, 'abbreviation'))]"
  >
    <abbr>
      <xsl:attribute name="title">
        <xsl:analyze-string select="@otherprops" regex="[a-z]*\([^\)]*\)">
          <xsl:matching-substring>
            <xsl:variable name="var">
              <xsl:value-of select="."/>
            </xsl:variable>
            <xsl:variable name="attr">
              <xsl:value-of select="substring-before($var, '(')"/>
            </xsl:variable>
            <xsl:attribute name="{$attr}">
              <xsl:value-of select="substring-before(substring-after($var, '('),')')"/>
            </xsl:attribute>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:attribute>
      <xsl:call-template name="commonattributes"/>
      <xsl:call-template name="setidaname"/>
      <xsl:apply-templates/>
    </abbr>
  </xsl:template>

  <xsl:template match="*" mode="addFooterToHtmlBodyElement">
    <xsl:variable name="footer-content" as="node()*">
      <xsl:call-template name="gen-user-footer"/> <!-- include user's XSL running footer here -->
      <xsl:call-template name="processFTR"/>      <!-- Include XHTML footer, if specified -->
    </xsl:variable>
    <xsl:if test="exists($footer-content)">
      <footer xsl:use-attribute-sets="footer">
        <!-- ↓ Add Bootstrap CSS ↓ -->
        <xsl:attribute name="class">
          <xsl:value-of select="$BOOTSTRAP_CSS_FOOTER"/>
          <xsl:if test="not($TOC_SPACER_PADDING = '0')">
            <xsl:value-of select="concat(' py-', $TOC_SPACER_PADDING)"/>
          </xsl:if>
        </xsl:attribute>
        <xsl:sequence select="$footer-content"/>
        <!-- ↓ Add Bootstrap CSS ↓ -->
      </footer>
    </xsl:if>
  </xsl:template>

  <!-- list item -->
  <xsl:template match="*[contains(@class, ' topic/li ')]" name="topic.li">
    <li>
      <xsl:choose>
        <xsl:when test="parent::*/@compact = 'no'">
          <!-- handle non-compact list items -->
          <xsl:call-template name="commonattributes">
            <xsl:with-param name="default-output-class" select="'py-3'"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="parent::*/@compact = 'yes'">
          <!-- handle non-compact list items -->
          <xsl:call-template name="commonattributes">
            <xsl:with-param name="default-output-class" select="'py-0'"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="commonattributes"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:call-template name="setidaname"/>
      <xsl:apply-templates/>
    </li>
  </xsl:template>
</xsl:stylesheet>
