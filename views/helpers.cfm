<!--- Place helper functions here that should be available for use in all view pages of your application. --->

<cffunction name="linkToIf" access="public" returnType="string" output="false">
	<cfargument name="condition" type="boolean" required="true"/>
	<cfargument name="text" type="string" required="true"/>

	<cfreturn arguments.condition ? arguments.text : linkTo(argumentCollection = arguments)/>

</cffunction>