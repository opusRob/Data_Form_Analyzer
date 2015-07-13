<!---
	This is the parent controller file that all your controllers should extend.
	You can add functions to this file to make them globally available in all your controllers.
	Do not delete this file.
--->

<cfcomponent extends="Wheels">

	<cffunction name="hasTagMatch" returnType="boolean" access="public" output="false">
		<cfargument name="strString" type="string" required="true"/>
		<cfargument name="strTagName" type="string" required="true"/>
		<cfargument name="strSeparator" type="string" default=""/>

		<cfreturn arrayLen(reMatchNoCase("\{#arguments.strTagName##len(arguments.strSeparator) ? arguments.strSeparator : ''#[^\}]*\}", arguments.strString)) GT 0/>
	</cffunction>

	<cffunction name="getTagMatch" returnType="string" access="public" output="false">
		<cfargument name="strString" type="string" required="true"/>
		<cfargument name="strTagName" type="string" required="true"/>
		<cfargument name="strSeparator" type="string" default=""/>

		<cfif hasTagMatch(argumentCollection = arguments)>
			<cfreturn reMatchNoCase("\{#arguments.strTagName##len(arguments.strSeparator) ? arguments.strSeparator : ''#[^\}]*\}", arguments.strString)[1]/>
		<cfelse>
			<cfreturn ""/>
		</cfif>
	</cffunction>

	<cffunction name="getTagContent" returnType="string" access="public" output="false">
		<cfargument name="strString" type="string" required="true"/>
		<cfargument name="strTagName" type="string" required="true"/>
		<cfargument name="strSeparator" type="string" default=""/>

		<cfif hasTagMatch(argumentCollection = arguments)>
			<cfreturn trim(reReplaceNoCase(getTagMatch(argumentCollection = arguments), "(\{#arguments.strTagName##len(arguments.strSeparator) ? arguments.strSeparator : ''#|\})", "", "all"))/>
		<cfelse>
			<cfreturn ""/>
		</cfif>
	</cffunction>

	<cffunction name="getTabLevel" returnType="numeric" access="public" output="false">
		<cfargument name="strString" type="string" required="true"/>

		<cfreturn reFind("[^\t]", arguments.strString) - 1/>

	</cffunction>

	<cffunction name="getFieldLabel" returnType="string" access="public" output="false">
		<cfargument name="strString" type="string" required="true"/>

		<cfreturn trim(reReplace(arguments.strString, "{[^\{\}]*}", "", "all"))/>

	</cffunction>

	<cffunction name="getParentFieldID" returnType="numeric" access="public" output="false">
		<cfargument name="intTabLevel" type="numeric" required="true"/>
		<cfargument name="qryData" type="query" required="true"/>

		<cfquery name="local.qryData" dbtype="query">
			SELECT MAX(field_id) AS parent_field_id
			FROM arguments.qryData
			WHERE tab_level < <cfqueryparam value="#arguments.intTabLevel#"/>
		</cfquery>

		<cfreturn val(local.qryData.parent_field_id)/>

	</cffunction>

	<cffunction name="parseFileContent" returnType="query" access="public" output="true">
		<cfargument name="strFileContent" required="true"/>
		<cfargument name="strFileName" default=""/>
		<cfargument name="strFormName" default=""/>

		<cfset arguments.strFileContent = trim(arguments.strFileContent)/>

		<cfset local.qryData = queryNew(
			"file_name"
				& ",form_name"
				& ",section"
				& ",subsection"
				& ",page"
				& ",field_id"
				& ",parent_field_id"
				& ",field_number"
				& ",data_type"
				& ",field_label"
				& ",field_label_stripped"
				& ",tab_level"
			, "varchar"
				& ",varchar"
				& ",varchar"
				& ",varchar"
				& ",integer"
				& ",integer"
				& ",integer"
				& ",varchar"
				& ",varchar"
				& ",varchar"
				& ",varchar"
				& ",integer"
		)/>

		<cfset local.strSection = ""/>
		<cfset local.strSubSection = ""/>
		<cfset local.intPage = 0/>
		<cfset local.intFieldID = 0/>
		<cfset local.strFieldNumber = ""/>
		<cfset local.strDataType = ""/>
		<cfset local.strFieldLabel = ""/>
		<cfset local.strFieldLabelStripped = ""/>
		<cfset local.intTabLevel = 0/>
		<cfset local.intParentFieldID = 0/>

		<cfloop list="#arguments.strFileContent#" index="local.strFileLine" delimiters="#chr(10)##chr(13)#">
			<cfscript>
				//section name
				if (hasTagMatch(local.strFileLine, "section", ":"))
					local.strSection = getTagContent(local.strFileLine, "section", ":");

				//Sub-section name
				if (hasTagMatch(local.strFileLine, "subSection", ":"))
					local.strSubSection = getTagContent(local.strFileLine, "subSection", ":");

				//Page
				if (hasTagMatch(local.strFileLine, "p"))
					local.intPage = getTagContent(local.strFileLine, "p");

				//File line number
				if (hasTagMatch(local.strFileLine, "f"))
					local.strFieldNumber = getTagContent(local.strFileLine, "f");

				//Data type
				if (hasTagMatch(local.strFileLine, "dt", ":"))
					local.strDataType = getTagContent(local.strFileLine, "dt", ":");

				//Field label
				local.strFieldLabel = getFieldLabel(local.strFileLine);

				//Field label stripped of any non-alpha/numeric chars, and doubled spaces/tabs
				local.strFieldLabelStripped = lCase(reReplaceNoCase(local.strFieldLabel, "[^a-zA-Z0-9\s_]", "", "all"));
				local.strFieldLabelStripped = trim(reReplace(local.strFieldLabelStripped, "\s", chr(32), "all"));
				while (find("#chr(32)##chr(32)#", local.strFieldLabelStripped)) {
					local.strFieldLabelStripped = replace(local.strFieldLabelStripped, "#chr(32)##chr(32)#", chr(32), "all");
				}

				//Tab/indent level
				local.intTabLevel = getTabLevel(local.strFileLine);

				/*---------------------------------------------------------------------------------------------*/
				if (hasTagMatch(local.strFileLine, "dt", ":")) {
					//Field ID
					local.intFieldID++;

					//Parent field id
					local.intParentFieldID = getParentFieldID(local.intTabLevel, local.qryData);

					queryAddRow(local.qryData);
					querySetCell(local.qryData, "file_name", arguments.strFileName);
					querySetCell(local.qryData, "form_name", arguments.strFormName);
					querySetCell(local.qryData, "section", local.strSection);
					querySetCell(local.qryData, "subsection", local.strSubSection);
					querySetCell(local.qryData, "page", local.intPage);
					querySetCell(local.qryData, "field_id", local.intFieldID);
					querySetCell(local.qryData, "field_number", local.strFieldNumber);
					querySetCell(local.qryData, "data_type", local.strDataType);
					querySetCell(local.qryData, "field_label", local.strFieldLabel);
					querySetCell(local.qryData, "field_label_stripped", local.strFieldLabelStripped);
					querySetCell(local.qryData, "tab_level", local.intTabLevel);
					querySetCell(local.qryData, "parent_field_id", local.intParentFieldID);
				}
			</cfscript>

		</cfloop>

		<cfreturn local.qryData/>

	</cffunction>

	<cffunction name="queryMerge" returnType="query" access="public" output="true">
		<cfargument name="aryQueries" type="array" required="true"/>

		<cfset local.qryData = duplicateQueryStructure(arguments.aryQueries[1])/>
		<cfset local.lstQueryColumns = getQueryFieldsInfo(getMetaData(arguments.aryQueries[1])).lstQueryColumns/>

		<cfloop array="#arguments.aryQueries#" index="local.x">
			<cfquery name="local.qryData" dbtype="query">
				SELECT
					<cfset local.iCount = 0/>
					<cfloop list="#local.lstQueryColumns#" index="local.i">
						<cfset local.iCount++/>
						#local.iCount GT 1 ? ', ' : ''#[#local.i#]
					</cfloop>
				FROM qryData
				UNION ALL
				SELECT
					<cfset local.iCount = 0/>
					<cfloop list="#local.lstQueryColumns#" index="local.i">
						<cfset local.iCount++/>
						#local.iCount GT 1 ? ', ' : ''#[#local.i#]
					</cfloop>
				FROM x
			</cfquery>
		</cfloop>

		<cfreturn local.qryData/>

	</cffunction>

	<cffunction name="getQueryFieldsInfo" returnType="struct" access="public" output="true">
		<cfargument name="aryQueryMetaInfo" type="array" required="true"/>

		<cfset local.stcData = { lstQueryColumns = "", lstQueryDataTypes = "" }/>

		<cfloop array="#arguments.aryQueryMetaInfo#" index="local.i">
			<cfset local.stcData.lstQueryColumns = listAppend(local.stcData.lstQueryColumns, local.i.Name)/>
			<cfset local.stcData.lstQueryDataTypes = listAppend(local.stcData.lstQueryDataTypes, local.i.TypeName)/>
		</cfloop>

		<cfreturn local.stcData/>

	</cffunction>

	<cffunction name="duplicateQueryStructure" returnType="query" access="public" output="true">
		<cfargument name="qryData" type="query" required="true"/>

		<cfset local.stcData = getQueryFieldsInfo(getMetaData(arguments.qryData))/>

		<cfreturn queryNew(
			local.stcData.lstQueryColumns
			, local.stcData.lstQueryDataTypes
		)/>

	</cffunction>

	<cffunction name="getQueryFieldDataType" returnType="string" access="public" output="true">
		<cfargument name="qryData" type="query" required="true"/>
		<cfargument name="strField" type="string" required="true">

		<cfset local.stcQueryInfo = this.getQueryFieldsInfo(getMetaData(arguments.qryData))/>

		<cfreturn listGetAt(
			local.stcQueryInfo.lstQueryDataTypes
			, listFindNoCase(local.stcQueryInfo.lstQueryColumns, arguments.strField)
		)/>

	</cffunction>

	<cffunction name="getDistinctFieldsFromQuery" returnType="query" access="public" output="true">
		<cfargument name="qryData" type="query" required="true"/>
		<cfargument name="aryFieldList" type="array" default="#arrayNew(1)#"/>
		<!--- [{strFieldName = "field_label", strBefore = "MAX(", strAfter = ")", strAlias = "field_label"}] --->

		<cfif NOT arrayLen(arguments.aryFieldList)>
			<cfset local.aryQueryColumns = arrayNew(1)/>
			<cfloop list="#this.getQueryFieldsInfo(arguments.qryData).lstQueryColumns#" index="local.i">
				<cfset local.aryQueryColumns = arrayAppend(local.aryQueryColumns, {strFieldName = local.i})/>
			</cfloop>
		<cfelse>
			<cfset local.aryQueryColumns = arguments.aryFieldList/>
		</cfif>

		<cfquery name="local.qryData" dbtype="query">
			SELECT
				<cfset local.iCount = 0/>
				<cfloop array="#local.aryQueryColumns#" index="local.i">
					<cfset local.strCurrentColumn = structKeyExists(local.i, "strBefore") ? local.i.strBefore : ""/>
					<cfset local.strCurrentColumn &= "[" & local.i.strFieldName & "]"/>
					<cfset local.strCurrentColumn &= structKeyExists(local.i, "strAfter") ? local.i.strAfter : ""/>
					<cfset local.strCurrentColumn &= structKeyExists(local.i, "strAlias") ? " AS [#local.i.strAlias#]" : ""/>

					<cfset local.iCount++/>
					#local.iCount GT 1 ? ', ' : ''##local.strCurrentColumn#
				</cfloop>
			FROM arguments.qryData
			<cfset local.iCount = 0/>
			<cfloop array="#local.aryQueryColumns#" index="local.i">
				<cfif NOT (structKeyExists(local.i, "bolExcludeFromGroupBy") AND local.i.bolExcludeFromGroupBy)>
					<cfset local.iCount++/>
					#local.iCount EQ 1 ? "GROUP BY" : ","# #"[" & local.i.strFieldName & "]"#
				</cfif>
			</cfloop>
			ORDER BY
				<cfset local.iCount = 0/>
				<cfloop array="#local.aryQueryColumns#" index="local.i">
					<cfset local.iCount++/>
					#local.iCount GT 1 ? ', ' : ''#[#structKeyExists(local.i, "strAlias") ? local.i.strAlias : local.i.strFieldName#]
				</cfloop>
		</cfquery>

		<cfreturn local.qryData/>

	</cffunction>

	<cffunction name="queryGetData" returnType="query" access="public" output="true">
		<cfargument name="qryData" type="query" required="true"/>
		<cfargument name="aryFields" type="array" default="#arrayNew(1)#"/>
		<cfargument name="aryFormatFunctions" type="array" default="#arrayNew(1)#"/>
		<cfargument name="aryValues" type="array" default="#arrayNew(1)#"/>

		<cfquery name="local.qryData" dbtype="query">
			SELECT *
			FROM arguments.qryData
			<cfif arrayLen(arguments.aryFields) AND arrayLen(arguments.aryFields) EQ arrayLen(arguments.aryValues)>
				<cfset local.iCount = 0/>
				<cfloop array="#arguments.aryFields#" index="local.i">
					<cfset local.iCount++/>
					#local.iCount EQ 1 ? "WHERE" : "AND"# #len(arguments.aryFormatFunctions[local.iCount]) ? "#arguments.aryFormatFunctions[local.iCount]#([#local.i#])" : "[#local.i#]"#
						= <cfqueryparam
							value="#arguments.aryValues[local.iCount]#"
							cfsqltype="cf_sql_#this.getQueryFieldDataType(arguments.qryData, local.i)#"
						/>
				</cfloop>
			</cfif>
		</cfquery>

		<cfreturn local.qryData/>

	</cffunction>

	<cffunction name="listToArrayOfStructs" returnType="array" access="public" output="true">
		<cfargument name="strList" type="string" required="true"/>
		<cfargument name="strStructKeyName" type="string" required="true"/>
		<cfargument name="strDelimiters" type="string" default=","/>

		<cfset local.aryData = arrayNew(1)/>

		<cfloop list="#arguments.strList#" index="local.i" delimiters="#arguments.strDelimiters#">
			<cfset local.aryData = arrayAppend(local.aryData, {"#arguments.strStructKeyName#" = local.i})/>
		</cfloop>

		<cfreturn local.aryData/>

	</cffunction>

</cfcomponent>