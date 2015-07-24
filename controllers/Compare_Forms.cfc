<cfcomponent extends="Controller">

	<cffunction name="compare_forms" returnType="any" access="public" output="true">
		<!--- If form.file_paths is defined and has a value: --->
		<cfif isDefined("form.file_paths") AND len(trim(form.file_paths))>
			<!--- Upload the submitted file(s): --->
			<cffile
				action="uploadAll"
				destination="#getDirectoryFromPath(expandPath(cgi.script_name))#files\temporary_uploads\"
				accept="text/plain"
				nameconflict="overwrite"
				result="request.aryFiles"
			/>

			<!--- Define the new array that will hold our data: --->
			<cfset request.aryFileQueries = arrayNew(1)/>

			<!--- Loop over the array of files that were uploaded by the CFFILE tag above: --->
			<cfloop array="#request.aryFiles#" index="request.i">
				<!--- If the file exists: --->
				<cfif fileExists(request.i.serverDirectory & "\" & request.i.serverFile)>
					<!--- Read the file's contents: --->
					<cffile action="read" file="#request.i.serverDirectory#\#request.i.serverFile#" variable="request.strFileContent"/>

					<!--- Grab the file's form name from the file's content using the getTagContent() function: --->
					<cfset request.strFormName = getTagContent(request.strFileContent, "formName", ":")/>

					<!--- Append to our new array the query returned by running the file through the parseFileContent() function, which parses the file's lines into query rows, with each field populated by that line's markup: --->
					<cfset arrayAppend(
						request.aryFileQueries
						, parseFileContent(
							request.strFileContent
							, request.i.clientFile
							, request.strFormName
						)
					)/>
				</cfif>

			</cfloop>

			<!--- Get the column list (in order - hence getColumnList() instead of columnList) from the first query in our new array: --->
			<cfset request.lstQueryColumns = arrayToList(request.aryFileQueries[1].getColumnList())/>

			<!--- Merge all the queries contained in our new array into a new single query using the queryMerge() function: --->
			<cfset request.qryData = queryMerge(request.aryFileQueries)/>


			<!--- Prepare the second argument that will be used in the first getDistinctFieldsFromQuery() call below, which will involve the field_label_stripped and field_label fields (the latter being a SQL expression):  --->
			<cfset local.aryCheckData = [
				{strFieldName = "field_label_stripped"}
				, {strFieldName = "field_label", strBefore = "MAX(", strAfter = ")", strAlias = "field_label", bolExcludeFromGroupBy = true}
			]/>

			<!--- If the include_data_type checkbox was checked in the submitted form, prepare and add it to the second argument that will be used in the first getDistinctFieldsFromQuery() call below: --->
			<cfif structKeyExists(form, "include_data_type")>
				<cfset arrayAppend(
					local.aryCheckData
					, {strFieldName = "data_type", strBefore = "LOWER(", strAfter = ")", strAlias = "data_type"}
				)/>
			</cfif>

			<!--- Get the distinct fields specfied in local.aryCheckData (just set above) from our merged query using the getDistinctFieldsFromQuery() function: --->
			<cfset request.qryFieldLabels = getDistinctFieldsFromQuery(request.qryData, local.aryCheckData)/>

			<!--- Get distinct list of form names for which there is data in our merged query using the getDistinctFieldsFromQuery() function: --->
			<cfset request.qryFormNames = getDistinctFieldsFromQuery(request.qryData, [{strFieldName = "form_name"}])/>
		</cfif>
	</cffunction>

</cfcomponent>