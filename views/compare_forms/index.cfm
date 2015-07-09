<div class="page-header">
	<h1>Compare Forms</h1>
</div>

<cfoutput>
	#startFormTag(action = "compare_forms", encType = "multipart/form-data")#

	<ol id="file_list">
		<cfloop from="1" to="20" index="variables.i">
			<li class="list_item">
				#fileFieldTag(
					name = "file_path_#variables.i#"
					, label = "Choose File: "
					, class = "form-control"
				)#
				#linkTo(text = "Remove", class="remove_list_item_link", href="##")#
			</li>
		</cfloop>
		<li id="li_add_file">
			#buttonTag(type = "button", id="add_file", content="Add Another File", class="btn btn-success")#
		</li>
	</ol>

	#submitTag(value = "Compare Forms", class="btn btn-primary")#

	#endFormTag()#

</cfoutput>