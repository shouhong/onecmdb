<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text" encoding="iso-8859-1"/>
<xsl:template match="/">
"Application.Type","Application.name","Application.Version","Application.Port","Application.Protocol","OS.Type","OS.Version","System.Type","System.IPAddress","System.Hostname","Network.Name"
<xsl:for-each select="Tree/application">
<xsl:text>"</xsl:text><xsl:value-of select="@type"/><xsl:text>"</xsl:text><xsl:text>,</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="Name" /><xsl:text>"</xsl:text><xsl:text>,</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="Version" /><xsl:text>"</xsl:text><xsl:text>,</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="Port" /><xsl:text>"</xsl:text><xsl:text>,</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="Protocol" /><xsl:text>"</xsl:text><xsl:text>,</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="application2os/os/@type" /><xsl:text>"</xsl:text><xsl:text>,</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="application2os/os/Version" /><xsl:text>"</xsl:text><xsl:text>,</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="application2os/os/os2system/system/@type" /><xsl:text>"</xsl:text><xsl:text>,</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="application2os/os/os2system/system/IPAddress" /><xsl:text>"</xsl:text><xsl:text>,</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="application2os/os/os2system/system/Hostname" /><xsl:text>"</xsl:text><xsl:text>,</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="application2os/os/os2system/system/system2network/network/Name" /><xsl:text>"</xsl:text>,
</xsl:for-each>

</xsl:template>

</xsl:stylesheet>