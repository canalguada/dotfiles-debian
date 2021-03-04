# -*- coding: utf-8 -*-
# vim: set ai ts=4 sw=4 tw=79:

# pylint: disable=missing-module-docstring,too-many-lines
# pylint: disable=undefined-variable,line-too-long
# pep8: disable=E501

# Autogenerated config.py
# Documentation:
#   qute://help/configuring.html
#   qute://help/settings.html

# This is here so configs done via the GUI are still loaded.
# Remove it to not load settings done via the GUI.
config.load_autoconfig()

# # Dracula theme
# import dracula.draw

# dracula.draw.blood(c, {
# 'spacing': {
# 'vertical': 6,
# 'horizontal': 8
# }
# })

# Nord theme
config.source('nord-qutebrowser.py')

# Always restore open sites when qutebrowser is reopened.
# Type: Bool
c.auto_save.session = True

# Backend to use to display websites. qutebrowser supports two different
# web rendering engines / backends, QtWebKit and QtWebEngine. QtWebKit
# was discontinued by the Qt project with Qt 5.6, but picked up as a
# well maintained fork: https://github.com/annulen/webkit/wiki -
# qutebrowser only supports the fork. QtWebEngine is Qt's official
# successor to QtWebKit. It's slightly more resource hungry than
# QtWebKit and has a couple of missing features in qutebrowser, but is
# generally the preferred choice.
# Type: String
# Valid values:
#   - webengine: Use QtWebEngine (based on Chromium).
#   - webkit: Use QtWebKit (based on WebKit, similar to Safari).
c.backend = 'webkit'
#c.backend = 'webengine'

# Which categories to show (in which order) in the :open completion.
# Type: FlagList
# Valid values:
#   - searchengines
#   - quickmarks
#   - bookmarks
#   - history
c.completion.open_categories = ['bookmarks',
                                'history', 'searchengines', 'quickmarks']

# A list of patterns which should not be shown in the history. This only
# affects the completion. Matching URLs are still saved in the history
# (and visible on the qute://history page), but hidden in the
# completion. Changing this setting will cause the completion history to
# be regenerated on the next start, which will take a short while.
# Type: List of UrlPattern
c.completion.web_history.exclude = ['*://duckduckgo.com/*']

# Require a confirmation before quitting the application.
# Type: ConfirmQuit
# Valid values:
#   - always: Always show a confirmation.
#   - multiple-tabs: Show a confirmation if multiple tabs are opened.
#   - downloads: Show a confirmation if downloads are running
#   - never: Never show a confirmation.
c.confirm_quit = ['downloads']

# Automatically start playing `<video>` elements. Note: On Qt < 5.11,
# this option needs a restart and does not support URL patterns.
# Type: Bool
c.content.autoplay = False

# Maximum number of pages to hold in the global memory page cache. The
# page cache allows for a nicer user experience when navigating forth or
# back to pages in the forward/back history, by pausing and resuming up
# to _n_ pages. For more information about the feature, please refer to:
# http://webkit.org/blog/427/webkit-page-cache-i-the-basics/
# Type: Int
c.content.cache.maximum_pages = 8

# Which cookies to accept.
# Type: String
# Valid values:
#   - all: Accept all cookies.
#   - no-3rdparty: Accept cookies from the same origin only. This is known to break some sites, such as GMail.
#   - no-unknown-3rdparty: Accept cookies from the same origin only, unless a cookie is already set for the domain. On QtWebEngine, this is the same as no-3rdparty.
#   - never: Don't accept cookies at all.
c.content.cookies.accept = 'no-unknown-3rdparty'

# Enable JavaScript.
# Type: Bool
c.content.javascript.enabled = False

# Allow pdf.js to view PDF files in the browser. Note that the files can
# still be downloaded by clicking the download button in the pdf.js
# viewer.
# Type: Bool
c.content.pdfjs = True

# Draw the background color and images also when the page is printed.
# Type: Bool
c.content.print_element_backgrounds = False

# Enable WebGL.
# Type: Bool
c.content.webgl = False

# Which interfaces to expose via WebRTC. On Qt 5.10, this option doesn't
# work because of a Qt bug.
# Type: String
# Valid values:
#   - all-interfaces: WebRTC has the right to enumerate all interfaces and bind them to discover public interfaces.
#   - default-public-and-private-interfaces: WebRTC should only use the default route used by http. This also exposes the associated default private address. Default route is the route chosen by the OS on a multi-homed endpoint.
#   - default-public-interface-only: WebRTC should only use the default route used by http. This doesn't expose any local addresses.
#   - disable-non-proxied-udp: WebRTC should only use TCP to contact peers or servers unless the proxy server supports UDP. This doesn't expose any local addresses either.
c.content.webrtc_ip_handling_policy = 'default-public-interface-only'

# Monitor load requests for cross-site scripting attempts. Suspicious
# scripts will be blocked and reported in the inspector's JavaScript
# console. Note that bypasses for the XSS auditor are widely known and
# it can be abused for cross-site info leaks in some scenarios, see:
# https://www.chromium.org/developers/design-documents/xss-auditor
# Type: Bool
c.content.xss_auditing = True

# Editor (and arguments) to use for the `open-editor` command. The
# following placeholders are defined:  * `{file}`: Filename of the file
# to be edited. * `{line}`: Line in which the caret is found in the
# text. * `{column}`: Column in which the caret is found in the text. *
# `{line0}`: Same as `{line}`, but starting from index 0. * `{column0}`:
# Same as `{column}`, but starting from index 0.
# Type: ShellCommand
c.editor.command = ['Editor', '{file}']

# Font family for cursive fonts.
# Type: FontFamily
c.fonts.web.family.cursive = 'Lexie Readable'

# Font family for fixed fonts.
# Type: FontFamily
c.fonts.web.family.fixed = 'Fira Mono'

# Font family for sans-serif fonts.
# Type: FontFamily
c.fonts.web.family.sans_serif = 'Aleo Light'

# Font family for serif fonts.
# Type: FontFamily
c.fonts.web.family.serif = 'Aller Light'

# Font family for standard fonts.
# Type: FontFamily
c.fonts.web.family.standard = 'Aleo Light'

# Make characters in hint strings uppercase.
# Type: Bool
c.hints.uppercase = True

# Enable spatial navigation. Spatial navigation consists in the ability
# to navigate between focusable elements in a Web page, such as
# hyperlinks and form controls, by using Left, Right, Up and Down arrow
# keys. For example, if the user presses the Right key, heuristics
# determine whether there is an element he might be trying to reach
# towards the right and which element he probably wants.
# Type: Bool
c.input.spatial_navigation = True

# When to show the scrollbar.
# Type: String
# Valid values:
#   - always: Always show the scrollbar.
#   - never: Never show the scrollbar.
#   - when-searching: Show the scrollbar when searching for text in the webpage. With the QtWebKit backend, this is equal to `never`.
c.scrolling.bar = 'always'

# Enable smooth scrolling for web pages. Note smooth scrolling does not
# work with the `:scroll-px` command.
# Type: Bool
c.scrolling.smooth = True

# Load a restored tab as soon as it takes focus.
# Type: Bool
c.session.lazy_restore = True

# Languages to use for spell checking. You can check for available
# languages and install dictionaries using scripts/dictcli.py. Run the
# script with -h/--help for instructions.
# Type: List of String
c.spellcheck.languages = ['en-US', 'fr-FR']

# How to behave when the close mouse button is pressed on the tab bar.
# Type: String
# Valid values:
#   - new-tab: Open a new tab.
#   - close-current: Close the current tab.
#   - close-last: Close the last tab.
#   - ignore: Don't do anything.
c.tabs.close_mouse_button_on_bar = 'close-current'

# How to behave when the last tab is closed.
# Type: String
# Valid values:
#   - ignore: Don't do anything.
#   - blank: Load a blank page.
#   - startpage: Load the start page.
#   - default-page: Load the default page.
#   - close: Close the window.
c.tabs.last_close = 'startpage'

# Position of new tabs which are not opened from another tab. See
# `tabs.new_position.stacking` for controlling stacking behavior.
# Type: NewTabPosition
# Valid values:
#   - prev: Before the current tab.
#   - next: After the current tab.
#   - first: At the beginning.
#   - last: At the end.
c.tabs.new_position.unrelated = 'next'

# Which tab to select when the focused tab is removed.
# Type: SelectOnRemove
# Valid values:
#   - prev: Select the tab which came before the closed one (left in horizontal, above in vertical).
#   - next: Select the tab which came after the closed one (right in horizontal, below in vertical).
#   - last-used: Select the previously selected tab.
c.tabs.select_on_remove = 'last-used'

# Width (in pixels or as percentage of the window) of the tab bar if
# it's vertical.
# Type: PercOrInt
c.tabs.width = '15%'

# c.content.headers.user_agent = 'Mozilla/5.0 (Windows NT 9.0; WOW64; Trident/7.0; rv:11.0)'
# c.content.headers.user_agent = 'Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.36 (KHTML, like Gecko) qutebrowser/1.13.1 Chrome/77.0.3865.129 Safari/537.36'
# c.content.headers.user_agent = 'Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.36 (KHTML, like Gecko) qutebrowser/1.13.1'

config.bind('<z><l>', 'spawn --userscript qute-pass')
config.bind('<z><u><l>', 'spawn --userscript qute-pass --username-only')
config.bind('<z><p><l>', 'spawn --userscript qute-pass --password-only')
config.bind('<z><o><l>', 'spawn --userscript qute-pass --otp-only')

# End of default configuration