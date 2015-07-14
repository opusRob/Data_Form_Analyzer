
<cfoutput>
	#linkTo(text = "Compare More Forms", action = "index")#

	<table class="table table-striped table-bordered th_rotated_45">
		<tr>
			<th class="data_form_headers"><div><span>&nbsp;</span></div></th>
			<th class="data_form_headers"><div><span>Field Label</span></div></th>
			<cfif structKeyExists(form, "include_data_type")>
				<th class="data_form_headers"><div><span>Data Type</span></div></th>
			</cfif>
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
				<cfif structKeyExists(form, "include_data_type")>
					<td><span>#request.qryFieldLabels.data_type#</span></td>
				</cfif>
				<cfloop query="request.qryFormNames">
					<!--- Temporarily using the inline CFQUERY block below, because the commented-out queryGetData(...) call further down is causing a strange error. --->
					<cfquery name="variables.qryHasField" dbtype="query">
						SELECT 1 AS [x]
						FROM request.qryData
						WHERE [field_label_stripped] = <cfqueryparam value="#request.qryFieldLabels.field_label_stripped#" cfsqltype="cf_sql_varchar"/>
							<cfif structKeyExists(form, "include_data_type")>
								AND LOWER([data_type]) = <cfqueryparam value="#lCase(request.qryFieldLabels.data_type)#" cfsqltype="cf_sql_varchar"/>
							</cfif>
							AND LOWER([form_name]) = <cfqueryparam value="#lCase(request.qryFormNames.form_name)#" cfsqltype="cf_sql_varchar"/>
					</cfquery>
					<td><span>#yesNoFormat(variables.qryHasField.recordCount GT 0)#</span></td>
					<!--- <td><span>#yesNoFormat(
						queryGetData(
							qryData = request.qryData
							, aryFields = ["field_label_stripped", "data_type", "form_name"]
							, aryFormatFunctions = ["", "LOWER", "LOWER"]
							, aryValues = [
								request.qryFieldLabels.field_label_stripped
								, lCase(request.qryFieldLabels.data_type)
								, lCase(request.qryFormNames.form_name)
							]
						).recordCount GT 0
					)#</span></td> --->
				</cfloop>
			</tr>
		</cfloop>
	</table>

</cfoutput>