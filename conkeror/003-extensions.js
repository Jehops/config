// cookie culler
const cookie_culler_chrome = "chrome://cookieculler/content/CookieCuller.xul";

interactive("cookie-culler-dialog", "Show the CookieCuller settings in a dialog box.",
	    function (I) {
		var frame = I.buffer.top_frame;
		frame.openDialog(cookie_culler_chrome,
				 "CookieCuller",
				 "centerscreen,chrome,dialog,modal,resizable");
	    });

interactive("cookie-culler", "Open the CookieCuller settings in a new buffer.",
	    "find-url-new-buffer",
	    $browser_object = cookie_culler_chrome);

// firebug
define_variable("firebug_url",
    "http://getfirebug.com/releases/lite/1.2/firebug-lite-compressed.js");

function firebug (I) {
    var doc = I.buffer.document;
    var script = doc.createElement('script');
    script.setAttribute('type', 'text/javascript');
    script.setAttribute('src', firebug_url);
    script.setAttribute('onload', 'firebug.init();');
    doc.body.appendChild(script);
}
interactive("firebug", "open firebug lite", firebug);

// mozrepl
user_pref('extensions.mozrepl.autoStart', true);

let (mozrepl_init = get_home_directory()) {
    mozrepl_init.appendRelativePath(".mozrepl-conkeror.js");
    session_pref('extensions.mozrepl.initUrl', make_uri(mozrepl_init).spec);
}

// uBlock (via ebzzry)
interactive(
    "ublock", "Open uBlock dashboard in a new buffer",
    function (I) {
        load_url_in_new_buffer("chrome://ublock/content/dashboard.html");
    }
);