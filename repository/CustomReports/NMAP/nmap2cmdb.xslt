
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="/Tree">
			<xsl:for-each select="network">
						Network
						<xsl:for-each select="host2network/host">
						    Host
							<xsl:for-each select="port2host/port">
								Port
							</xsl:for-each>
						</xsl:for-each>
				</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>