
<cfoutput>
	<span style="font-weight: bold; ">#request.objFile.clientFile#</span>
	&nbsp;&nbsp;&nbsp;&nbsp;
	#linkTo(text = "View Another Form", action = "index")#

	<table class="table table-striped table-bordered">
		<tr>
			<th>&nbsp;</th>
			<cfloop list="#request.lstQueryColumns#" index="request.c">
				<th>#request.c#</th>
			</cfloop>
		</tr>
		<cfif request.qryData.recordCount>
			<cfloop query="request.qryData">
				<tr>
					<td>#request.qryData.currentRow#</td>
					<cfloop list="#request.lstQueryColumns#" index="request.c">
						<cfset request.cell_value = evaluate("request.qryData." & request.c)/>
						<td>#len(trim(request.cell_value)) ? request.cell_value : "&nbsp;"#</td>
					</cfloop>
				</tr>
			</cfloop>
		<cfelse>
			<tr>
				<td colspan="#listLen(request.lstQueryColumns) + 1#">No record returned.</td>
			</tr>
		</cfif>
	</table>
</cfoutput>