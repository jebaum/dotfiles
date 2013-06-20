//!javascript
//<adblock_subscriptions___SCRIPT
extensions.load("adblock_subscriptions", {
//<adblock_subscriptions___CONFIG

// Shortcut to subscribe to a filterlist
scSubscribe : null, 
// Command to subscribe to a filterlist
cmdSubscribe : "adblock_subscribe", 

// Shortcut to unsubscribe from a filterlist
scUnsubscribe : null, 

// Command to unsubscribe from a filterlist
cmdUnsubscribe : "adblock_unsubscribe",

// Shortcut to update subscriptions and reload filter rules
// Note that dwb will also update all subscriptions on startup
scUpdate : null, 

// Command to update subscriptions and reload filter rules
// Note that dwb will also update all subscriptions on startup
cmdUpdate : "adblock_update", 

// Path to the filterlist directory, will be created if it doesn't exist. 
filterListDir : data.configDir + "/adblock_lists"
//>adblock_subscriptions___CONFIG

});
//>adblock_subscriptions___SCRIPT
//<userscripts___SCRIPT
extensions.load("userscripts", {
//<userscripts___CONFIG
  // paths to userscripts, this extension will also load all scripts in 
  // $XDG_CONFIG_HOME/dwb/greasemonkey, it will also load all scripts in
  // $XDG_CONFIG_HOME/dwb/scripts but this is deprecated and will be
  // disabled in future versions.
  scripts : []
//>userscripts___CONFIG
});
//>userscripts___SCRIPT
//<perdomainsettings___SCRIPT
extensions.load("perdomainsettings", {
//<perdomainsettings___CONFIG
// Only webkit builtin settings can be set, for a list of settings see
// http://webkitgtk.org/reference/webkitgtk/unstable/WebKitWebSettings.html
// All settings can also be used in camelcase, otherwise they must be quoted.
//
// The special domain suffix .tld matches all top level domains, e.g.
// example.tld matches example.com, example.co.uk, example.it ...
//
// Settings based on uri will override host based settings and host based
// settings will override domain based settings. Settings for domains/hosts/uris
// with without tld suffix will override settings for
// domains/hosts/uris with tld suffix respectively, e.g.
//      "example.com" : { enableScripts : true },
//      "example.tld" : { enableScripts : false }
// will enable scripts on example.com but not on example.co.uk, example.it, ...


// Settings applied based on the second level domain
domains : {
        "archlinux.org"     : { "user-stylesheet-uri" : "file:///home/james/.config/dwb/userstyles/archlinux.css" },
        "bitbucket.org"     : { "user-stylesheet-uri" : "file:///home/james/.config/dwb/userstyles/bitbucket.css" },
        "facebook.com"      : { "user-stylesheet-uri" : "file:///home/james/.config/dwb/userstyles/facebook.css" },
        "github.com"        : { "user-stylesheet-uri" : "file:///home/james/.config/dwb/userstyles/github.css" },
        "imdb.com"          : { "user-stylesheet-uri" : "file:///home/james/.config/dwb/userstyles/imdb.css" },
        "lifehacker.com"    : { "user-stylesheet-uri" : "file:///home/james/.config/dwb/userstyles/lifehacker.css" },
        "reddit.com"        : { "user-stylesheet-uri" : "file:///home/james/.config/dwb/userstyles/reddit.css" },
        "stackoverflow.com" : { "user-stylesheet-uri" : "file:///home/james/.config/dwb/userstyles/stackoverflow.css" },
        "thepiratebay.sx"   : { "user-stylesheet-uri" : "file:///home/james/.config/dwb/userstyles/tpb.css" },
        "twitch.tv"         : { "user-stylesheet-uri" : "file:///home/james/.config/dwb/userstyles/twitch.css" },
        "wikipedia.org"     : { "user-stylesheet-uri" : "file:///home/james/.config/dwb/userstyles/wiki.css" },
        "youtube.com"       : { "user-stylesheet-uri" : "file:///home/james/.config/dwb/userstyles/youtube.css" },
        "google.com"        : { "user-stylesheet-uri" : "file:///home/james/.config/dwb/userstyles/google.css" },
//      "example.com" : { "auto-load-images" : false },
//      "google.tld" : { enableScripts : false, autoLoadImages : false },
},

//Settings applied based on the hostname
hosts : {
//    "www.example.com" : { autoLoadImages : true }
},

// Settings applied based on the uri
uris : {
//  "http://www.example.com/foo/" : { autoLoadImages : true } },
},

//>perdomainsettings___CONFIG

});
//>perdomainsettings___SCRIPT
//<formfiller___SCRIPT
extensions.load("formfiller", {
//<formfiller___CONFIG
// shortcut that gets and saves formdata
scGetForm : "efg",

// shortcut that fills a form
scFillForm : "eff",

// path to the formdata file
formData : data.configDir + "/forms",

// whether to use a gpg-encrypted file
useGPG : false,

// your GPG key ID (leave empty to use a symmetric cipher)
GPGKeyID : "",

// whether to use a GPG agent (requires non-empty GPGKeyID to work)
GPGAgent : false,

// additional arguments passed to gpg2 when encrypting the formdata
GPGOptEncrypt : "",

// additional arguments passed to gpg2 when decrypting the formdata
GPGOptDecrypt : "",

// whether to save the password in memory when gpg is used
keepPassword : true,

// whether to save the whole formdata in memory when gpg is used
keepFormdata : false

//>formfiller___CONFIG
});
//>formfiller___SCRIPT
//<unique_tabs___SCRIPT
extensions.load("unique_tabs", {
//<unique_tabs___CONFIG
// Shortcut that removes duplicate tabs
shortcutRemoveDuplicates : null,

// Command that removes duplicate tabs
commandRemoveDuplicates : "ut_remove_duplicates",

// Autofocus a tab if an url is already opened, if the url would be loaded in a
// new tab the new tab is closed. 
// Setting this to true makes commandRemoveDuplicates and
// shortcutRemoveDuplicates obsolete because there will be no duplicates. 
autoFocus : true,

// Shortcut for toggling autofocus
shortcutToggleAutoFocus : null, 

// Command for toggling autofocus
commandToggleAutoFocus : "ut_toggle_autofocus", 

//>unique_tabs___CONFIG
});
//>unique_tabs___SCRIPT
//<supergenpass___SCRIPT
extensions.load("supergenpass", {
//<supergenpass___CONFIG
// Compatibility mode, always generate passwords that are
// compatible with the original supergenpass bookmarklet
compat : true,

// Additional salts that are added on a domain basis. 
// domainSalts has to be an object of the form
// { "example.com" : "foo", "example.co.uk" : "bar" }
// In Compatibility mode domain salts are disabled
domainSalts : {},

// The hash-algorithm to use, either ChecksumType.md5,
// ChecksumType.sha1 or ChecksumType.sha256, in
// compatibility mode it is set to ChecksumType.md5
hashMethod : ChecksumType.md5,

// Length of the password, the minimum length is 4, the
// maximum length depends on the hashMethod, for md5 it is
// 24, for sha1 it is 28 and for sha256 it is 44. 
length : 24, 

// Minimum number of rehashes, in compatibility mode it is
// set to 10
rehash : 10, 

// A salt that will additionally be added to the password, 
// in compatibility mode set to ""
salt : "", 

// Whether to save the master password or ask every time
// a password is generated
saveMasterPassword : false, 

// The shortcut to invoke this extension
shortcut : "ep",

// A shortcut that prints the generated password to stdout
// instead of injecting it into the website
shortcutPrint :  "",

// Whether to strip subdomains
stripSubdomains : true
//>supergenpass___CONFIG

});
//>supergenpass___SCRIPT
