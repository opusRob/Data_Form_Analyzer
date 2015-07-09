
<cfoutput>
	#linkTo(text = "Compare More Forms", action = "index")#
	<table class="table table-striped table-bordered">
		<tr>
			<th>&nbsp;</th>
			<th>Field Label</th>
			<th>Data Type</th>
			<cfloop query="request.qryFormNames">
				<th>#request.qryFormNames.form_name#</th>
			</cfloop>
		</tr>
		<cfloop query="request.qryFieldLabels">
			<tr>
				<td>#request.qryFieldLabels.currentRow#</td>
				<td>#request.qryFieldLabels.field_label#</td>
				<td>#request.qryFieldLabels.data_type#</td>
				<cfloop query="request.qryFormNames">
					<td>#yesNoFormat(
						queryGetData(
							request.qryData
							, ["field_label", "data_type", "form_name"]
							, [request.qryFieldLabels.field_label, request.qryFieldLabels.data_type, request.qryFormNames.form_name]
						).recordCount GT 0
					)#</td>
				</cfloop>
			</tr>
		</cfloop>
	</table>

</cfoutput>