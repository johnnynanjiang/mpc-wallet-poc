//
//  BridgeScriptJS.swift
//  UniPass_Swift
//
//  Created by leven on 2022/11/11.
//

import Foundation
import WebKit
let JAVASCRIPT_BRIDGE_NAME = "flutter_inappwebview"
let JAVASCRIPT_BRIDGE_JS_PLUGIN_SCRIPT_GROUP_NAME = "IN_APP_WEBVIEW_JAVASCRIPT_BRIDGE_JS_PLUGIN_SCRIPT"

let WEB_MESSAGE_CHANNELS_VARIABLE_NAME = "window.\(JAVASCRIPT_BRIDGE_NAME)._webMessageChannels"

let WINDOW_ID_JS_PLUGIN_SCRIPT_GROUP_NAME = "IN_APP_WEBVIEW_WINDOW_ID_JS_PLUGIN_SCRIPT"

let WINDOW_ID_VARIABLE_JS_SOURCE = "window._\(JAVASCRIPT_BRIDGE_NAME)_windowId"

let VAR_PLACEHOLDER_VALUE = "$IN_APP_WEBVIEW_PLACEHOLDER_VALUE"


let WINDOW_ID_INITIALIZE_JS_SOURCE = """
(function() {
    \(WINDOW_ID_VARIABLE_JS_SOURCE) = \(VAR_PLACEHOLDER_VALUE);
    return \(WINDOW_ID_VARIABLE_JS_SOURCE);
})()
"""

let JAVASCRIPT_BRIDGE_JS_PLUGIN_SCRIPT = WKUserScript(source: JAVASCRIPT_BRIDGE_JS_SOURCE, injectionTime: .atDocumentStart, forMainFrameOnly: false)

let JAVASCRIPT_BRIDGE_JS_SOURCE = """
window.\(JAVASCRIPT_BRIDGE_NAME) = {};
\(WEB_MESSAGE_CHANNELS_VARIABLE_NAME) = {};
window.\(JAVASCRIPT_BRIDGE_NAME).callHandler = function() {
    var _windowId = \(WINDOW_ID_VARIABLE_JS_SOURCE);
    var _callHandlerID = setTimeout(function(){});
    window.webkit.messageHandlers['callHandler'].postMessage( {'handlerName': arguments[0], '_callHandlerID': _callHandlerID, 'args': JSON.stringify(Array.prototype.slice.call(arguments, 1)), '_windowId': _windowId} );
    return new Promise(function(resolve, reject) {
        window.\(JAVASCRIPT_BRIDGE_NAME)[_callHandlerID] = resolve;
    });
};
"""
