<div class="page-header">
	<h1>View Form</h1>
</div>

<cfoutput>
	#startFormTag(action = "view_form", encType = "multipart/form-data")#

	#fileFieldTag(
		name = "file_path"
		, label = "Choose File: "
		, class = "form-control"
	)#

	<br />

	#submitTag(value = "View File")#

	#endFormTag()#

</cfoutput>