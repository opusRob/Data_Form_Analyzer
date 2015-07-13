
$(document).ready(
	function() {
		
	
		$(".table.th_rotated_45 tr:first th")
			.css("white-space", "nowrap")
			.css("text-align", "left")
			.css("vertical-align", "bottom")
			.children("div")
				.css("padding", "0px")
				.css("transform-origin", "top left")
				.css("transform", "rotate(-45deg)")
				.children("span")
					.css("border-bottom", "solid 1px #ccc")
					.css("background", "#ffcc00")
					.css("padding", "5px");
		
		$(".table.th_rotated_45 tr:first th").each(
			function(c) {
				$(this).children("div:first").css(
					"width"		
					, String(
						getTableColumnContentMaxWidth({
							objTable: $(".table.th_rotated_45:first")
							, intColumn: c
							, intStartRow: 2
						})
					) + "px"
				);
				
				// console.log($(this).children("div:first").children("span:first").width());
				// console.log($(this).children("div:first").children("span:first").position());
				console.log(getRotatedBoxBoundingBoxDimensions({
					intWidth: $(this).children("div:first").children("span:first").outerWidth()
					, intHeight: $(this).children("div:first").children("span:first").outerHeight()
					, intAngle: getRotatedBoxAngle($(this).children("div:first"))
				}));
				//getRotatedBoxAngle($(this).children("div:first"));
			}
		);
		
		$(".table.th_rotated_45 tr:first").find("th, td").first().css(
			"height"
			, String(getTableRowContentMaxHeight({
				objTable: $(".table.th_rotated_45:first")
				, intRow: 0
			})) + "px"
		);
		
	}
);

function getTableRowContentMaxHeight(arguments) {
	//arguments {objTable, intRow, intStartCol, intEndCol}
	
	var intMaxHeight = 0;
	
	if (!("intStartCol" in arguments)) {
		arguments["intStartCol"] = 0;
	}
	
	var aryCols = $(arguments.objTable).find("tr").eq(arguments.intRow).find("td, th");
	
	if (!("intEndCol" in arguments)) {
		arguments["intEndCol"] = Math.max(0, aryCols.length - 1);
	}
	
	for (c = arguments.intStartCol; c <= arguments.intEndCol; c++) {
		intMaxHeight = Math.max(intMaxHeight, $(aryCols[c]).find("span:first").height());
	}
	
	return intMaxHeight;
	
}

function getTableColumnContentMaxWidth(arguments) {
	//arguments {objTable, intColumn, intStartRow, intEndRow}
	
	var intMaxWidth = 0;
	
	if (!("intStartRow" in arguments)) {
		arguments["intStartRow"] = 0;
	}
	
	var aryRows = $(arguments.objTable).find("tr");
	
	if (!("intEndRow" in arguments)) {
		arguments["intEndRow"] = Math.max(0, aryRows.length - 1);
	}
	
	for (r = arguments.intStartRow; r <= arguments.intEndRow; r++) {
		intMaxWidth = Math.max(intMaxWidth, $(aryRows[r]).children("td, th").eq(arguments.intColumn).children("span:first").width());
	}
	
	return intMaxWidth;
	
}

function getRotatedBoxBoundingBoxDimensions(arguments) {
	//intWidth, intHeight, intAngle
	console.log(arguments);
	
	var int1 = (arguments.intWidth * Math.sin(Math.abs(arguments.intAngle)));
	var int2 = (arguments.intWidth * Math.sin(Math.abs(arguments.intAngle)));

	return {
		intBoundingHeight: (
			(arguments.intWidth * Math.sin(Math.abs(arguments.intAngle)))
			+ (arguments.intHeight * Math.sin(Math.abs(arguments.intAngle)))
		)
		, intBoundingWidth: (arguments.intWidth * Math.sin(Math.abs(arguments.intAngle)))
	};
	
}

function getRotatedBoxAngle(objRotatedBox) {
	// var el = document.getElementById("thing");
	// var st = window.getComputedStyle(el, null);
	// var tr = st.getPropertyValue("-webkit-transform") ||
	         // st.getPropertyValue("-moz-transform") ||
	         // st.getPropertyValue("-ms-transform") ||
	         // st.getPropertyValue("-o-transform") ||
	         // st.getPropertyValue("transform") ||
	         // "FAIL";
// 	
	// // With rotate(30deg)...
	// // matrix(0.866025, 0.5, -0.5, 0.866025, 0px, 0px)
	// console.log('Matrix: ' + tr);
	
	// rotation matrix - http://en.wikipedia.org/wiki/Rotation_matrix
	var strMatrix = $(objRotatedBox).css("transform");
	var values = strMatrix.split('(')[1].split(')')[0].split(',');
	var a = values[0];
	var b = values[1];
	var c = values[2];
	var d = values[3];
	
	var scale = Math.sqrt(a*a + b*b);
	
	//console.log('Scale: ' + scale);
	
	// arc sin, convert from radians to degrees, round
	var sin = b/scale;
	// next line works for 30deg but not 130deg (returns 50);
	// var angle = Math.round(Math.asin(sin) * (180/Math.PI));
	var angle = Math.round(Math.atan2(b, a) * (180/Math.PI));
	
	//console.log('Rotate: ' + angle);
	
	return angle;
	
}
