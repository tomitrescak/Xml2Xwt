<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text" indent="no"  />

    <xsl:template match="Window">
using System;
using Xwt;
using Xwt.Drawing;
using System.Xml;

namespace <xsl:value-of select="Namespace" />
{
    public partial class <xsl:value-of select="Name" /> : Window
    {
        <xsl:call-template name="InitVariables" />

        private void Init() {

            <xsl:call-template name="InitProperties">
                <xsl:with-param name="var" select="''" />
            </xsl:call-template>
            <xsl:apply-templates select="StatusIcon" />
            <xsl:apply-templates select="MainMenu" />
            <xsl:apply-templates select="Content" />
        }
    }
}
    </xsl:template>

    <xsl:template match="StatusIcon">
            try {
                <xsl:value-of select="@name" /> = Application.CreateStatusIcon ();
                <xsl:value-of select="@name" />.Image = Image.FromResource (GetType (), "<xsl:value-of select="Image/@resourceId" />");
            <xsl:if test="Menu">
                <xsl:apply-templates select="Menu" />
                <xsl:value-of select="@name" />.Menu = <xsl:value-of select="Menu/@name" />;
            </xsl:if>
            } catch {
                Console.WriteLine ("Status icon could not be shown");
            }

    </xsl:template>

    <xsl:template match="MainMenu">
        <xsl:apply-templates select="Menu" />
        MainMenu = <xsl:value-of select="Menu/@name" />;
    </xsl:template>

    <xsl:template match="Content">
        <xsl:apply-templates />
        Content = <xsl:value-of select="child::*[1]/@name" />;
    </xsl:template>

    <!-- Menu template rendering nested menus -->
    <xsl:template match="Menu">
        <xsl:param name="var" select="@name" />
            <xsl:value-of select="$var" /> = new Menu ();
        <xsl:apply-templates select="MenuItem" />
        <xsl:for-each select="MenuItem">
            <xsl:value-of select="$var"/>.Items.Add (<xsl:value-of select="@name" />);
        </xsl:for-each>
        <xsl:call-template name="InitProperties" />
    </xsl:template>

    <!-- MenuItem template-->
    <xsl:template match="MenuItem"><xsl:value-of select="@name" /> = new MenuItem("<xsl:value-of select="@title" />");
        <xsl:if test="@onclick">
            <xsl:value-of select="@name" />.Clicked += <xsl:value-of select="@onclick" />;
        </xsl:if>
        <!-- proceed children -->
        <xsl:if test="count(MenuItem) > 0">
            <xsl:apply-templates select="MenuItem">
                <xsl:with-param name="var" select="@name" />
            </xsl:apply-templates>
            <xsl:value-of select="@name" />.SubMenu = new Menu();
            <xsl:variable name="var" select="@name" />
            <xsl:for-each select="MenuItem">
                <xsl:value-of select="$var"/>.SubMenu.Items.Add (<xsl:value-of select="@name" />);
            </xsl:for-each>
        </xsl:if>
        <xsl:call-template name="InitProperties" />
    </xsl:template>

    <!-- HPaned -->
    <xsl:template match="HPaned|VPaned"><xsl:value-of select="@name" /> = new <xsl:value-of select="name()"/> ();<xsl:apply-templates select="Panel1|Panel2" />
        <xsl:value-of select="@name" />.Panel1.Content = <xsl:value-of select="Panel1/*[1]/@name" />;
        <xsl:value-of select="@name" />.Panel2.Content = <xsl:value-of select="Panel2/*[1]/@name" />;
        <xsl:call-template name="InitProperties" />
    </xsl:template>

    <xsl:template match="Panel1"><xsl:apply-templates /></xsl:template>
    <xsl:template match="Panel2"><xsl:apply-templates /></xsl:template>

    <xsl:template match="HBox|VBox">
        <xsl:value-of select="@name" /> = new <xsl:value-of select="name()" />();
        <xsl:apply-templates />
        <xsl:for-each select="*[@name != '']">
            <xsl:choose>
                <xsl:when test="pack = 'end'">
                    <xsl:value-of select="parent::*/@name" />.PackEnd(<xsl:value-of select="@name" />);
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="parent::*/@name" />.PackStart(<xsl:value-of select="@name" />);
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:call-template name="InitProperties" />
    </xsl:template>

    <xsl:template match="Canvas">
        <xsl:value-of select="@name" /> = new <xsl:value-of select="name()" />();
        <xsl:apply-templates />
        <xsl:for-each select="*[@name != '']">
            <xsl:value-of select="parent::*/@name" />.AddChild(<xsl:value-of select="@name" />, new Rectangle(<xsl:value-of
                select="Position" />));
        </xsl:for-each>
        <xsl:call-template name="InitProperties" />
    </xsl:template>

    <xsl:template match="Icon">
        <xsl:value-of select="@name" /> = Image.FromResource (GetType(), "<xsl:value-of select="ResourceId" />");
        <xsl:call-template name="InitProperties" />
    </xsl:template>

    <xsl:template match="TreeView"><xsl:value-of select="@name" /> = new TreeView();
        <xsl:apply-templates />
        <xsl:if test="TreeStore">
            <xsl:value-of select="@name" />.DataSource = <xsl:value-of select="TreeStore/@name"/>;
        </xsl:if>
    </xsl:template>

    <xsl:template match="TreeStore">
        <xsl:value-of select="@name" /> = new TreeStore(<xsl:value-of select="DataField[1]/@ref"/><xsl:for-each select="DataField[position() > 1]">, <xsl:value-of select="@ref"/></xsl:for-each>);
    </xsl:template>

    <xsl:template match="Column">
        <xsl:value-of select="parent::*/@name" />.Columns.Add("<xsl:value-of select="@title" />"<xsl:for-each select="DataField">, <xsl:value-of select="@ref"/></xsl:for-each>);
    </xsl:template>
    
    <xsl:template match="*"><xsl:if test="@name">
            <xsl:value-of select="@name" /> = new <xsl:value-of select="name()" />();
            <xsl:call-template name="InitProperties" />
        </xsl:if>
    </xsl:template>

    <xsl:template name="InitVariables">
        <xsl:for-each select="//*[@name != '']">
            <xsl:choose>
                <xsl:when test="name() = 'DataField'">
                    <xsl:value-of select="name()" />
                    <xsl:text disable-output-escaping="yes"><![CDATA[<]]></xsl:text>
                    <xsl:value-of select="@type"/>
                    <xsl:text disable-output-escaping="yes"><![CDATA[>]]></xsl:text>&#xA0;<xsl:value-of select="@name" /> = new DataField<xsl:text disable-output-escaping="yes"><![CDATA[<]]></xsl:text><xsl:value-of select="@type"/><xsl:text disable-output-escaping="yes"><![CDATA[>]]></xsl:text>();
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="name()" />&#xA0;<xsl:value-of select="@name" />;
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="InitProperties">
        <xsl:param name="var" select="concat(@name, '.')" />
        <xsl:for-each select="@*">
            <xsl:if test="name() != 'name' and name() != 'title' and name() != 'namespace'">
                <xsl:value-of select="$var"/><xsl:value-of select="name()" /> = <xsl:value-of select="." />;
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="Event">
            <xsl:value-of select="$var"/><xsl:value-of select="name(@*[1])" /> += <xsl:value-of select="@*[1]" />;
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>