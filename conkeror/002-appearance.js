// minibuffer colours
register_user_stylesheet(
    "data:text/css," +
    escape (
	"@namespace XUL_NS;\n" +
	    " #minibuffer, .mode-line {" + 
	    " background-color:black;" + 
	    " color:white;" + 
	    "-moz-appearance:none;" + 
	    " border-top: 0px;}"));

// hint font size
register_user_stylesheet(
    "data:text/css," +
	escape(
            "@namespace url(\"http://www.w3.org/1999/xhtml\");\n" +
		"span.__conkeror_hint {"+
		" font-size: 12px !important;"+
		" line-height: 12px !important;"+
		"}"));

// hint colours 
register_user_stylesheet(
    "data:text/css," +
        escape (
            "span.__conkeror_hint {" +
		" border: 1px solid #dddddd !important;" +
		" color: white !important;" +
		" background-color: black !important;" +
		"}"));