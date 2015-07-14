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
	#checkBoxTag(
		name = "include_data_type"
		, label = " Include Data Type"
		, labelPlacement = "aroundRight"
		, class = "checkbox-inline"
		, value = "1"
		, uncheckedValue = "0"
	)#
	<br />
	#submitTag(value = "Compare Forms", class="btn btn-primary")#

	#endFormTag()#

</cfoutput>