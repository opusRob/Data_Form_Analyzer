
function renumberFileFields() {
	$(".list_item").each(
		function(i) {
			$(this).children("input:first").attr("name", "file_path_" + String(i + 1));
			$(this).children("input:first").attr("id", "file_path_" + String(i + 1));
		}
	);
}

$(document).on(
	"click"
	, "#add_file"
	, function() {
		$("<li class=\"list_item\">" + $(".list_item:first").html() + "</li>").insertBefore("#li_add_file");
		renumberFileFields();
	}
);

$(document).on(
	"click"
	, ".remove_list_item_link"
	, function() {
		$(this).parent("li").detach();
		renumberFileFields();
		return false;
	}
);

$(document).on(
	"change"
	, "#comparison_type"
	, function() {
			var objSelectMenu = $(this);
			$("#include_data_type").prop("disabled", $(objSelectMenu).val() != "fields");
		}
);