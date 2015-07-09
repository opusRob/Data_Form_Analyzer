
component extends="Controller" {

	function new() {
		variables.user = model("user").new();
	}

	function create() {
		variables.user = model("user").create(params.user);
		redirectTo(
			action="index"
			, success="User #variables.user.name# created successfully."
		);
	}

	function index() {
		variables.users = model("user").findAll(order="name");
	}

}