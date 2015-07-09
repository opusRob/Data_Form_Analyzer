<cfdump var="#request.wheels.params#">

<cfoutput>
	<h1>Create a New User</h1>

	#startFormTag(action="create")#

	<div>
		#textField(
			objectName="user"
			, property="name"
			, label="Name"
		)#
	</div>
	<div>
		#textField(
			objectName="user"
			, property="email"
			, label="E-Mail"
		)#
	</div>
	<div>
		#textField(
			objectName="user"
			, property="password"
			, label="Password"
		)#
	</div>

	<div>#submitTag()#</div>

</cfoutput>