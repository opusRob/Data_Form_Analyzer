
<cfcomponent extends="Controller">

	<cffunction name="view_form" access="public" returnType="any" output="false">
		<cfif len(trim(form.file_path))>
			<cffile
				action="upload"
				destination="#getDirectoryFromPath(expandPath(cgi.script_name))#files\temporary_uploads\"
				accept="text/plain"
				filefield="file_path"
				nameconflict="overwrite"
				result="request.objFile"
			/>

			<cfif fileExists(request.objFile.serverDirectory & "\" & request.objFile.serverFile)>
				<cffile action="read" file="#request.objFile.serverDirectory#\#request.objFile.serverFile#" variable="request.strFileContent"/>

				<cfset request.strFormName = getTagContent(request.strFileContent, "formName", ":")/>

				<cfset request.qryData = parseFileContent(request.strFileContent, request.objFile.clientFile, request.strFormName)/>
				<cfset request.lstQueryColumns = arrayToList(request.qryData.getColumnList())/>

			</cfif>
		</cfif>
	</cffunction>

</cfcomponent>