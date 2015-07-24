<div class="page-header">
	<h1>Compare Forms</h1>
</div>

<cfoutput>
	#startFormTag(action = "compare_forms", encType = "multipart/form-data")#

	#fileFieldTag(
		name = "file_paths"
		, label = "Choose Files: "
		, class = "form-control"
		, multiple = "true"
	)#
	<br />
	#selectTag(
		name = "comparison_type"
		, label = "Comparison Type: "
		, class = "form-control"
		, options = [
			{id: "fields", value: "Fields"}
			, {id: "sections", value: "Sections"}
		]
		, valueField = "id"
		, textField = "value"
	)#
	<br />
	<label for="include_data_type">
		<input
			type="checkbox"
			name="include_data_type"
			id="include_data_type"
			class="checkbox-inline"
			value="1"
			#isDefined("form.include_data_type") AND form.include_data_type ? "checked" : ""#
		/>
		Include Data Type
	</label>
	<br />
	#submitTag(value = "Compare Forms", class="btn btn-primary")#

	#endFormTag()#

</cfoutput>