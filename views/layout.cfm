<!--- Place HTML here that should be used as the default layout of your application. --->

<html>


	<cfoutput>
		#javaScriptIncludeTag("jQuery/jquery-1.11.3")#

		#javaScriptIncludeTag("bootstrap/js/bootstrap.min")#
		#styleSheetLinkTag("bootstrap/css/bootstrap.min")#

		#styleSheetLinkTag("custom")#

		#request.wheels.params.controller IS "compare_forms" && request.wheels.params.action IS "index" ? javaScriptIncludeTag("compare_forms") : ""#
	</cfoutput>

	<body>


		<nav class="navbar navbar-default">
		  <div class="container-fluid">
		    <!-- Brand and toggle get grouped for better mobile display -->
		    <div class="navbar-header">
		      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
		        <span class="sr-only">Toggle navigation</span>
		        <span class="icon-bar"></span>
		        <span class="icon-bar"></span>
		        <span class="icon-bar"></span>
		      </button>
		      <a class="navbar-brand" href="#">Data Form Analyzer</a>
		    </div>

		    <!-- Collect the nav links, forms, and other content for toggling -->
		    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
		      <ul class="nav navbar-nav">
		        <!--- <li class="active"><a href="#">Link <span class="sr-only">(current)</span></a></li>
		        <li><a href="#">Link</a></li> --->
		        <cfoutput>
			        <li class="#request.wheels.params.controller IS 'home' ? 'active' : ''#">
						#linkTo(text = "Home", controller = "home", class = (request.wheels.params.controller IS "home" ? 'active' : ''))#
						<!--- #linkToIf(text = "Home", controller = "home", condition = request.wheels.params.controller IS "home")# --->
					</li>
			        <li class="#request.wheels.params.controller IS 'view_form' ? 'active' : ''#">
						#linkTo(text = "View Form", controller = "view_form", class = (request.wheels.params.controller IS "view_form" ? 'active' : ''))#
						<!--- #linkToIf(text = "View Form", controller = "view_form", condition = request.wheels.params.controller IS "view_form")# --->
					</li>
			        <li class="#request.wheels.params.controller IS 'compare_forms' ? 'active' : ''#">
						#linkTo(text = "Compare Forms", controller = "compare_forms", class = (request.wheels.params.controller IS "compare_forms" ? 'active' : ''))#
						<!--- #linkToIf(text = "Compare Forms", controller = "compare_forms", condition = request.wheels.params.controller IS "compare_forms")# --->
					</li>
				</cfoutput>
		      </ul>
		    </div><!-- /.navbar-collapse -->
		  </div><!-- /.container-fluid -->
		</nav>








	<!--- 	<nav class="navbar navbar-default">
			<div class="container-fluid">
				<cfoutput>
					#linkToIf(text = "Home", controller = "home", condition = request.wheels.params.controller IS "home")#
					|
					#linkToIf(text = "View Form", controller = "view_form", condition = request.wheels.params.controller IS "view_form")#
					|
					#linkToIf(text = "Compare Forms", controller = "compare_forms", condition = request.wheels.params.controller IS "compare_forms")#
				</cfoutput>
			</div>
		</nav> --->
		<div class="container theme-showcase" role="main">
			<cfoutput>#includeContent()#</cfoutput>
		</div>
	</body>
</html>