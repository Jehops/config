require("block-content-focus-change.js");
// ^ stop focus stealing (still breaks Google docs and other sites)
require("daemon");
require("dom-inspector");
require("favicon");
require("key-kill");
require("session.js");
require("user-agent-policy");

// completion
minibuffer_auto_complete_default = true;
url_completion_sort_order = 'date_descending';
url_completion_use_history = false;
url_completion_use_bookmarks = true;

// content handlers
external_content_handlers.set("application/pdf","emacsclient");
external_content_handlers.set("video/*","mpv");
external_content_handlers.set("text/*","emacsclient");

// downloading
// show download in a new buffer
// download_buffer_automatic_open_target = OPEN_NEW_BUFFER;
// don't automatically open the download window, use M-x download-show
remove_hook("download_added_hook", open_download_buffer_automatically);

// editing
editor_shell_command = "emacsclient";
view_source_use_external_editor = true;

// protocol handlers
set_protocol_handler("magnet",make_file("~/local/bin/magnet"));
set_protocol_handler("mailto",make_file("~/local/bin/em"));

// keybindings
undefine_key(content_buffer_normal_keymap,"b");
define_key(content_buffer_normal_keymap,"a","mpv");
define_key(content_buffer_normal_keymap,"h","find-url-from-history-new-buffer");
define_key(content_buffer_normal_keymap,"H","find-url-from-history");
undefine_key(content_buffer_normal_keymap,"u");
define_key(content_buffer_normal_keymap,"U","up");
define_key(content_buffer_normal_keymap,"C-g","unfocus");
define_key(text_keymap,"C-h","cmd_deleteCharBackward");

undefine_key(caret_keymap,"M-w");
define_key(caret_keymap,"M-w", "jrm_cmd_copy");
undefine_key(content_buffer_normal_keymap,"M-w");
define_key(content_buffer_normal_keymap,"M-w", "jrm_cmd_copy");
undefine_key(special_buffer_keymap,"M-w");
define_key(special_buffer_keymap,"M-w", "jrm_cmd_copy");
undefine_key(text_keymap,"M-w");
define_key(text_keymap,"M-w", "jrm_cmd_copy");

// in the minibuffer for isearch (did these ever work?)
//define_key(isearch_keymap,"C-a","scroll-beginning-of-line");
//define_key(isearch_keymap,"C-b","left");
//define_key(isearch_keymap,"C-e","scroll-end-of-line");
//define_key(isearch_keymap,"C-f","cmd_scrollRight");
//define_key(isearch_keymap,"C-k","cmd_scrollRight");

// key-kill-mode
key_kill_input_fields=true;
key_kill_mode.test.push(/\/\/.*github\.com\//i);
key_kill_mode.test.push(/\/\/.*google\.(ca|com)\//i);
key_kill_mode.test.push(/\/\/.*imgur\.com\//i);
key_kill_mode.test.push(/\/\/.*slashdot\.org\//i);
key_kill_mode.test.push(/\/\/.*twitter\.com\//i);
key_kill_mode.test.push(/\/\/.*youtube\.com\//i);
key_kill_mode.test.push(/\/\/forums\.freebsd\.org\//i);

// misc
block_content_focus_change_duration = 40; // See conkeror.org/Focus
can_kill_last_buffer = true; // using daemon mode
cwd = get_home_directory();
cwd.append("dl");
daemon_mode(1);
hint_digits = "abcdefghijklmnopqrstuvwxyz";
homepage = "about:blank";

// mode-line
add_hook("mode_line_hook",mode_line_adder(buffer_count_widget),true);
add_hook("mode_line_hook",mode_line_adder(buffer_icon_widget),true);
//add_hook("mode_line_hook",mode_line_adder(downloads_status_widget));
// ^ breaks all keybindings with Firefox 40+
add_hook("mode_line_hook",mode_line_adder(loading_count_widget),true);
//add_hook("mode_line_hook",mode_line_adder(zoom_widget));
// ^ doesn't seem to be working anymore
read_buffer_show_icons = true;  // favicons
remove_hook("mode_line_hook",mode_line_adder(clock_widget));
session_auto_save_auto_load = true;
url_remoting_fn = load_url_in_new_buffer;
xkcd_add_title = true;

// session / user preferences
// browser.download.manager.closeWhenDone applies to built-in d/l window
//session_pref("browser.download.manager.closeWhenDone",true);
session_pref("browser.tabs.remote.force-enable",true);
session_pref("full-screen-api.enabled",true);
// line below causes YouTube audio to continue after leaving page
session_pref("general.useragent.compatMode.firefox",true);
session_pref("layout.spellcheckDefault",1);
//session_pref("network.proxy.http","127.0.0.1");
//session_pref("network.proxy.http_port",8118);
//session_pref('network.proxy.ssl', "127.0.0.1");
//session_pref('network.proxy.ssl_port',8118);
//session_pref("network.proxy.type",1);
session_pref("spellchecker.dictionary","en-CA");
session_pref("xpinstall.whitelist.required",false);
user_pref("devtools.debugger.remote-enabled",true);
// user_pref("media.autoplay.enabled",false); // setting this breaks many videos
// set the default user agent, because Waterfox reports Firefox 1.0.4
//set_user_agent("Mozilla/5.0 (X11; FreeBSD amd64; rv:58.0) Gecko/20100101 Firefox/56.0.4 Waterfox/56.0.4");
//set_user_agent("Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/60.0");

// user agent
var user_agents = {
    "conkeror": null,
    "ipad": "Mozilla/5.0 (iPad; CPU OS 6_0 like Mac OS X) AppleWebKit/536.26 " +
        "(KHTML, like Gecko) Version/6.0 Mobile/10A5355d Safari/8536.25",
    "iphone": "Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_0 like Mac OS X; " +
        "en-us) AppleWebKit/532.9 (KHTML, like Gecko) Version/4.0.5 " +
        "Mobile/8A293 Safari/6531.22.7",
    "linux-chromium": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36" +
        "(KHTML, like Gecko) Chrome/41.0.2228.0 Safari/4E423F",
    "linux-firefox": user_agent_firefox()
};

// look into user_agent_policy

// webjumps
define_webjump("aw","awarnach.mathstat.dal.ca");
define_webjump("b","about:blank");
define_webjump("bn","http://bsd.network");
define_webjump("bs","dal.ca/brightspace");
define_webjump("c","http://calendar.google.com");
define_webjump("ca","capa.mathstat.dal.ca");
define_webjump("cbc","http://cbc.ca/news");
define_webjump("cg","https://www.freebsd.org/doc/en_US.ISO8859-1/articles/committers-guide/article.html");
define_webjump("cr","http://www.mathstat.dal.ca/~selinger/4116/");
define_webjump("d","https://duckduckgo.com/?q=%s");
define_webjump("f","http://forums.freebsd.org/find-new/posts");
define_webjump("fb","http://bugs.freebsd.org");
define_webjump("fh","http://freebsd.org/handbook");
define_webjump("fp","http://freshports.org/search.php?query=%s&search=go&num=100&stype=name&method=match&deleted=excludedeleted&start=1&casesensitivity=caseinsensitive");
define_webjump("fs","http://svnweb.freebsd.org");
define_webjump("gc","http://www.google.com/codesearch?q=%s");
define_webjump("gd","http://drive.google.com");
define_webjump("gi","http://images.google.com/images?q=%s");
define_webjump("gh","http://github.com");
define_webjump("gm","http://maps.google.ca/?force=tt&q=%s");
define_webjump("gp","http://photos.google.com");
define_webjump("gs","http://scholar.google.com/scholar?q=%s");
define_webjump("gt","http://translate.google.com");
define_webjump("h","https://ftfl.ca/bm/");
define_webjump("hn","https://news.ycombinator.com/");
define_webjump("chip","https://check.ipredator.se/");
define_webjump("m","http://mail.google.com");
define_webjump("mf","http://mastodon.ftfl.ca");
define_webjump("ms","http://mastodon.social");
define_webjump("n","http://awarnach.mathstat.dal.ca/nagios");
define_webjump("os","http://octodon.social");
define_webjump("npb", "https://bugs.freebsd.org/bugzilla/buglist.cgi?bug_status=New&component=Individual%20Port%28s%29&email1=ports-bugs%40FreeBSD.org&emailassigned_to1=1&emailtype1=substring&list_id=141853&product=Ports%20%26%20Packages&query_format=advanced");
define_webjump("ns","http://cbc.ca/ns");
define_webjump("p","http://pkg.awarnach.mathstat.dal.ca");
define_webjump("ph","https://www.freebsd.org/doc/en_US.ISO8859-1/books/porters-handbook/book.html");
define_webjump("ps","http://portscout.freebsd.org");
define_webjump("pw","https://picasaweb.google.com/lh/myphotos?noredirect=1");
define_webjump("rev","http://reviews.freebsd.org");
define_webjump("rbc","http://rbc.com");
define_webjump("rfc","http://www.ietf.org/rfc/rfc%s.txt",$alternative="http://www.ietf.org/rfc");
define_webjump("sim","http://simplii.ca");
define_webjump("so","http://stackoverflow.com/search?q=%s",$alternative="http://stackoverflow.com");
define_webjump("ss","javascript:window.location.href='http://google.com/search?q=%s+site:'+window.location.host");
define_webjump("t","http://www.thefreedictionary.com/%s#Thesaurus");
define_webjump("tilly","https://photos.google.com/share/AF1QipPF54v6sRJU2EpyvkvddDToiZKiqrQ5NqNbJebOeLyo2BhrOBhqoWjNWF7bO7a9fg?key=M09pWDBpczFaZmlzLWM3dmxpRXZmRjllZ3lSNjFB");
define_webjump("tpb","http://thepiratebay.org");
define_webjump("tw","http://twitter.com");
define_webjump("w","http://weather.gc.ca/city/pages/ns-40_metric_e.html");
define_webjump("wn","http://www.theweathernetwork.com/ca/weather/nova-scotia/halifax");
define_webjump("yt","http://www.youtube.com/results?search_query=%s&search=Search");
define_webjump("znc","https://ftfl.ca:2222");

// **************************** classes / functions ****************************

// Override function that names the file for the external editor (via
// escondida).  Original can be found in
// "${conkeror_src}"/modules/content-buffer-input.js
function external_editor_make_base_filename (elem,top_doc) {
    var name = "conkeror:"
        + top_doc.URL
        + "-"
        + ( elem.getAttribute("name")
            || elem.getAttribute("id")
            || elem.tagName.toLowerCase() );

    // remove filesystem unfriendly chars
    name = name.replace(top_doc.location.protocol,"")
        .replace(/[^a-zA-Z0-9.:_]+/g,"-")
        .replace(/(^-+|-+$)/g,"")
        .replace(/%20/g,"_")
        .replace(/:-/g,":");

    return name;
}

// Use org-protocol to store a link
function org_store_link (url,title,window) {
    var cmd_str = 'emacsclient \"org-protocol://store-link?url='+url+'&title='+title+'\"';
    if (window != null) {
        window.minibuffer.message('Issuing ' + cmd_str);
    }
    shell_command_blind(cmd_str);
}

interactive("org-store-link",
            "Stores [[url][title]] as org link; copies url to emacs kill ring",
            function (I) {
                org_store_link(encodeURIComponent(I.buffer.display_uri_string),
                               encodeURIComponent(I.buffer.document.title),
                               I.window);
            });

define_key(content_buffer_normal_keymap,"C-c o c","org-capture");

// Use org-protocol to capture a link
function org_capture (url,title,selection,window) {
    var cmd_str = 'emacsclient \"org-protocol://capture?template=w&url='+url+'&title='+title+'&body='+selection+'\"';
    if (window != null) {
        window.minibuffer.message('Issuing ' + cmd_str);
    }
    dumpln(cmd_str);
    shell_command_blind(cmd_str);
}

interactive("org-capture",
            "Clip url,title,and selection to capture via org-protocol",
            function (I) {
                org_capture(encodeURIComponent(I.buffer.display_uri_string),
                            encodeURIComponent(I.buffer.document.title),
                            encodeURIComponent(I.buffer.top_frame.getSelection()),
                            I.window);
            });

define_key(content_buffer_normal_keymap,"C-c o l","org-store-link");

// history
define_browser_object_class(
    "history-url",null,
    function (I,prompt) {
        check_buffer (I.buffer,content_buffer);
        var result = yield I.buffer.window.minibuffer.read_url(
            $prompt = prompt,$use_webjumps = false,$use_history = true,
            $use_bookmarks = false);
        yield co_return (result);
    });

interactive("find-url-from-history",
            "Find a page from history in the current buffer",
            "find-url",
            $browser_object = browser_object_history_url);

interactive("find-url-from-history-new-buffer",
            "Find a page from history in the current buffer",
            "find-url-new-buffer",
            $browser_object = browser_object_history_url);

interactive("browse-buffer-history",
            "Browse the session history for the current buffer",
            function browse_buffer_history (I) {
                var b = check_buffer(I.buffer,content_buffer);
                var history = b.web_navigation.sessionHistory;

                if (history.count > 1) {
                    var entries = [];

                    for(var i = 0 ; i < history.count ; i += 1) {
                        entries[i] = history.getEntryAtIndex(i,false).URI.spec;
                    }

                    var url = yield I.minibuffer.read(
                        $prompt = "Go back or forward to:",
                        $completer = new all_word_completer($completions = entries),
                        $default_completion = history.index > 0 ?
                            entries[history.index - 1] :
                            entries[history.index + 1],
                        $auto_complete = "url",
                        $auto_complete_initial = true,
                        $auto_complete_delay = 0,
                        $require_match = true);

                    b.web_navigation.gotoIndex(entries.indexOf(url));
                } else {
                    I.window.minibuffer.message("No history");
                }
            });

// Open the currently visited URL (or clipboard URL with a prefix) in Firefox
interactive(
    "ff","Open URL in Firefox",
    function (I) {
        var url;
        if (I.prefix_argument) url = read_from_x_primary_selection();
        else url = I.buffer.current_uri.spec;
        shell_command_with_argument_blind("firefox",url);
    }
);

function ekr (cc) {
    if (typeof cc === 'undefined') { cc = read_from_clipboard(); }
    // dumpln(cc);
    cc = cc.replace(/([^\\]*)\\([^\\]*)/g, "$1\\\\$2");
    cc = cc.replace(/"/g, '\\"');
    cc = cc.replace(/'/g, "'\\''");
    var ecc = "emacsclient -e '(kill-new \"" + cc + "\")' > /dev/null";
    // dumpln(ecc);
    shell_command_blind(ecc);
}

interactive(
    "jrm_cmd_copy",
    "Copy the selection to the clipboard and the Emacs kill ring",
    function (I) {
        call_builtin_command(I.window, "cmd_copy", true);
        ekr();
    }
);

// MPV (via scottj)
var mpv_default_command = "mpv";
var mpv_last_command = mpv_last_command || mpv_default_command;
interactive("mpv","Play url in mpv",
            function (I) {
                var cwd = I.local.cwd;
                var element = yield read_browser_object(I);
                var spec = load_spec(element);
                var uri = load_spec_uri_string(spec);

                uri = uri.replace('youtube.com','hooktube.com');

                var panel = create_info_panel(
                    I.window,
                    "download-panel",
                    [["downloading",
                      element_get_operation_label(element,"Running on","URI"),
                      load_spec_uri_string(spec)],
                     ["mime-type","Mime type:",load_spec_mime_type(spec)]]);

                try {
                    var cmd = yield I.minibuffer.read_shell_command(
                        $cwd = cwd,
                        $initial_value = mpv_last_command);
                    mpv_last_command = cmd;
                } finally {
                    panel.destroy();
                }

                shell_command_with_argument_blind(cmd+" {}",uri,$cwd = cwd);
            },
            $browser_object = browser_object_links);

// remote debugger
function start_debugging_server () {
    Components.utils.import('resource://gre/modules/devtools/dbg-server.jsm');
    if (!DebuggerServer.initialized) {
        DebuggerServer.init();
        DebuggerServer.addBrowserActors();
    }
    DebuggerServer.openListener(6001);
}

interactive("start-debugging-server",
            "Starts the debugging server that you can connect to with Firefox",
            start_debugging_server);

// revive buffer
define_key(default_global_keymap,"C-T","revive-buffer");

var kill_buffer_original = kill_buffer_original || kill_buffer;

var killed_buffer_urls = [];
var killed_buffer_histories = [];

//  remember_killed_buffer
kill_buffer = function (buffer,force) {
    var hist = buffer.web_navigation.sessionHistory;

    if (buffer.display_uri_string && hist) {
        killed_buffer_histories.push(hist);
        killed_buffer_urls.push(buffer.display_uri_string);
    }

    kill_buffer_original(buffer,force);
};

interactive("revive-buffer",
            "Loads url from a previously killed buffer",
            function restore_killed_buffer (I) {
                if (killed_buffer_urls.length !== 0) {
                    var url = yield I.minibuffer.read(
                        $prompt = "Restore killed url:",
                        $completer = new all_word_completer($completions = killed_buffer_urls),
                        $default_completion = killed_buffer_urls[killed_buffer_urls.length - 1],
                        $auto_complete = "url",
                        $auto_complete_initial = true,
                        $auto_complete_delay = 0,
                        $require_match = true);

                    var window = I.window;
                    var creator = buffer_creator(content_buffer);
                    var idx = killed_buffer_urls.indexOf(url);

                    // Create the buffer
                    var buf = creator(window,null);

                    // Recover the history
                    buf.web_navigation.sessionHistory = killed_buffer_histories[idx];

                    // This line may seem redundant, but it's necessary.
                    var original_index = buf.web_navigation.sessionHistory.index;
                    buf.web_navigation.gotoIndex(original_index);

                    // Focus the new tab
                    window.buffers.current = buf;

                    // Remove revived from cemitery
                    killed_buffer_urls.splice(idx,1);
                    killed_buffer_histories.splice(idx,1);
                } else {
                    I.window.minibuffer.message("No killed buffer urls");
                }
            });

// user agent (via escondida via retroj)
interactive("user-agent",
            "Pick a user agent from the list of presets",
            function (I) {
                var ua = (yield I.window.minibuffer.read_object_property(
                    $prompt = "Agent:",
                    $object = user_agents));
                set_user_agent(user_agents[ua]);
            });
