
<cfoutput>
	#linkTo(text = "Compare More Forms", action = "index")#

	<table class="table table-striped table-bordered th_rotated_45">
		<tr>
			<th class="data_form_headers"><div><span>&nbsp;</span></div></th>
			<th class="data_form_headers"><div><span>Field Label</span></div></th>
			<th class="data_form_headers"><div><span>Data Type</span></div></th>
			<cfloop query="request.qryFormNames">
				<th class="data_form_headers">
					<div>
						<span>#request.qryFormNames.form_name#</span>
					</div>
				</th>
			</cfloop>
		</tr>
		<cfloop query="request.qryFieldLabels">
			<tr>
				<td><span>#request.qryFieldLabels.currentRow#</span></td>
				<td><span>#request.qryFieldLabels.field_label#</span></td>
				<td><span>#request.qryFieldLabels.data_type#</span></td>
				<cfloop query="request.qryFormNames">
					<td><span>#yesNoFormat(
						queryGetData(
							request.qryData
							, ["field_label", "data_type", "form_name"]
							, [request.qryFieldLabels.field_label, request.qryFieldLabels.data_type, request.qryFormNames.form_name]
						).recordCount GT 0
					)#</span></td>
				</cfloop>
			</tr>
		</cfloop>
	</table>

</cfoutput>