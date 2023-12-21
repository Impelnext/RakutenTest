/**!
 * trunk8 v1.3.3
 * https://github.com/rviscomi/trunk8
 * 
 * Copyright 2012 Rick Viscomi
 * Released under the MIT License.
 * 
 * Date: September 26, 2012
 */

(function (root, factory) {
    if (typeof define === 'function' && define.amd) {
        define(['jquery'], factory);
    } else if (typeof module === 'object' && module.exports) {
        factory(require('jquery'));
    } else {
        factory(root.jQuery);
    }
}(this, function ($) {
    var methods,
        utils,
        SIDES = {
            /* cen...ter */
            center: 'center',
            /* ...left */
            left: 'left',
            /* right... */
            right: 'right'
        },
        WIDTH = {
            auto: 'auto'
        };
    
    function trunk8(element) {
        this.$element = $(element);
        this.original_text = $.trim(this.$element.html());
        this.settings = $.extend({}, $.fn.trunk8.defaults);
    }
    
    trunk8.prototype.updateSettings = function (options) {
        this.settings = $.extend(this.settings, options);
    };

    function stripHTML(html) {
        var tmp = document.createElement("DIV");
        tmp.innerHTML = html;
        
        if (typeof tmp.textContent != 'undefined') {
            return tmp.textContent;
        }

        return tmp.innerText
    }

    function getHtmlArr(str) {
        /* Builds an array of strings and designated */
        /* HTML tags around them. */
        if (stripHTML(str) === str) {
            return str.split(/\s/g);
        }
        var allResults = [],
            reg = /<([a-z]+)([^<]*)(?:>([\S\s]*?(?!<\1>))<\/\1>|\s+\/>)(['.?!,]*)|((?:[^<>\s])+['.?!,]*\w?|<br\s?\/?>)/ig,
            outArr = reg.exec(str),
            lastI,
            ind;
        while (outArr && lastI !== reg.lastIndex) {
            lastI = reg.lastIndex;
            if (outArr[5]) {
                allResults.push(outArr[5]);
            } else if (outArr[1]) {
                allResults.push({
                    tag: outArr[1],
                    attribs: outArr[2],
                    content: outArr[3],
                    after: outArr[4]
                });
            }
            outArr = reg.exec(str);
        }
        for (ind = 0; ind < allResults.length; ind++) {
            if (typeof allResults[ind] !== 'string' &&
                    allResults[ind].content) {
                allResults[ind].content = getHtmlArr(allResults[ind].content);
            }
        }
        return allResults;
    }

    function rebuildHtmlFromBite(bite, htmlObject, fill) {
        // Take the processed bite after binary-search
        // truncated and re-build the original HTML
        // tags around the processed string.
        bite = bite.replace(fill, '');

        var biteHelper = function(contentArr, tagInfo) {
                var retStr = '',
                    content,
                    biteContent,
                    biteLength,
                    nextWord,
                    i;
                for (i = 0; i < contentArr.length; i++) {
                    content = contentArr[i];
                    biteLength = $.trim(bite).split(' ').length;
                    if ($.trim(bite).length) {
                        if (typeof content === 'string') {
                            if (!/<br\s*\/?>/i.test(content)) {
                                if (biteLength === 1 && $.trim(bite).length <= content.length) {
                                    content = bite;
                                    // We want the fill to go inside of the last HTML
                                    // element if the element is a container.
                                    if (tagInfo === 'p' || tagInfo === 'div') {
                                        content += fill;
                                    }
                                    bite = '';
                                } else {
                                    bite = bite.replace(content, '');
                                }
                            }
                            retStr += $.trim(content) + ((i === contentArr.length-1 || biteLength <= 1) ? '' : ' ');
                        } else {
                            biteContent = biteHelper(content.content, content.tag);
                            if (content.after) bite = bite.replace(content.after, '');
                            if (biteContent) {
                                if (!content.after) content.after = ' ';
                                retStr += '<'+content.tag+content.attribs+'>'+biteContent+'</'+content.tag+'>' + content.after;
                            }
                        }
                    }
                }
                return retStr;
            },
            htmlResults = biteHelper(htmlObject);

        // Add fill if doesn't exist. This will place it outside the HTML elements.
        if (htmlResults.slice(htmlResults.length - fill.length) !== fill) {
            htmlResults += fill;
        }

        return htmlResults;
    }

    function truncate() {
        var data = this.data('trunk8'),
            settings = data.settings,
            width = settings.width,
            side = settings.side,
            fill = settings.fill,
            parseHTML = settings.parseHTML,
            line_height = utils.getLineHeight(this) * settings.lines,
            str = data.original_text,
            length = str.length,
            max_bite = '',
            lower, upper,
            bite_size,
            bite,
            text,
            htmlObject;
        
        /* Reset the field to the original string. */
        this.html(str);
        text = this.text();

        /* If string has HTML and parse HTML is set, build */
        /* the data struct to house the tags */
        if (parseHTML && stripHTML(str) !== str) {
            htmlObject = getHtmlArr(str);
            str = stripHTML(str);
            length = str.length;
        }

        if (width === WIDTH.auto) {
            /* Assuming there is no "overflow: hidden". */
            if (this.height() <= line_height) {
                /* Text is already at the optimal trunkage. */
                return;
            }

            /* Binary search technique for finding the optimal trunkage. */
            /* Find the maximum bite without overflowing. */
            lower = 0;
            upper = length - 1;

            while (lower <= upper) {
                bite_size = lower + ((upper - lower) >> 1);
                
                bite = utils.eatStr(str, side, length - bite_size, fill);

                if (parseHTML && htmlObject) {
                    bite = rebuildHtmlFromBite(bite, htmlObject, fill);
                }
                
                this.html(bite);

                /* Check for overflow. */
                if (this.height() > line_height) {
                    upper = bite_size - 1;
                }
                else {
                    lower = bite_size + 1;

                    /* Save the bigger bite. */
                    max_bite = (max_bite.length > bite.length) ? max_bite : bite;
                }
            }

            /* Reset the content to eliminate possible existing scroll bars. */
            this.html('');
            
            /* Display the biggest bite. */
            this.html(max_bite);
            
            if (settings.tooltip) {
                this.attr('data-title', text);
            }
        }
        else if (!isNaN(width)) {
            bite_size = length - width;

            bite = utils.eatStr(str, side, bite_size, fill);

            this.html(bite);
            
            if (settings.tooltip) {
                this.attr('data-title', str);
            }
        }
        else {
            $.error('Invalid width "' + width + '".');
            return;
        }
        settings.onTruncate();
    }

    methods = {
        init: function (options) {
            return this.each(function () {
                var $this = $(this),
                    data = $this.data('trunk8');
                
                if (!data) {
                    $this.data('trunk8', (data = new trunk8(this)));
                }
                
                data.updateSettings(options);
                
                truncate.call($this);
            });
        },

        /** Updates the text value of the elements while maintaining truncation. */
        update: function (new_string) {
            return this.each(function () {
                var $this = $(this);
                
                /* Update text. */
                if (new_string) {
                    $this.data('trunk8').original_text = new_string;
                }

                /* Truncate accordingly. */
                truncate.call($this);
            });
        },
        
        revert: function () {
            return this.each(function () {
                /* Get original text. */
                var text = $(this).data('trunk8').original_text;
                
                /* Revert element to original text. */
                $(this).html(text);
            });
        },

        /** Returns this instance's settings object. NOT CHAINABLE. */
        getSettings: function () {
            return $(this.get(0)).data('trunk8').settings;
        }
    };

    utils = {
        /** Replaces [bite_size] [side]-most chars in [str] with [fill]. */
        eatStr: function (str, side, bite_size, fill) {
            var length = str.length,
                key = utils.eatStr.generateKey.apply(null, arguments),
                half_length,
                half_bite_size;

            /* If the result is already in the cache, return it. */
            if (utils.eatStr.cache[key]) {
                return utils.eatStr.cache[key];
            }
            
            /* Common error handling. */
            if ((typeof str !== 'string') || (length === 0)) {
                $.error('Invalid source string "' + str + '".');
            }
            if ((bite_size < 0) || (bite_size > length)) {
                $.error('Invalid bite size "' + bite_size + '".');
            }
            else if (bite_size === 0) {
                /* No bite should show no truncation. */
                return str;
            }
            if (typeof (fill + '') !== 'string') {
                $.error('Fill unable to be converted to a string.');
            }

            /* Compute the result, store it in the cache, and return it. */
            switch (side) {
                case SIDES.right:
                    /* str... */
                    return utils.eatStr.cache[key] =
                            $.trim(str.substr(0, length - bite_size)) + fill;
                    
                case SIDES.left:
                    /* ...str */
                    return utils.eatStr.cache[key] =
                            fill + $.trim(str.substr(bite_size));
                    
                case SIDES.center:
                    /* Bit-shift to the right by one === Math.floor(x / 2) */
                    half_length = length >> 1; // halve the length
                    half_bite_size = bite_size >> 1; // halve the bite_size

                    /* st...r */
                    return utils.eatStr.cache[key] =
                            $.trim(utils.eatStr(str.substr(0, length - half_length), SIDES.right, bite_size - half_bite_size, '')) +
                            fill +
                            $.trim(utils.eatStr(str.substr(length - half_length), SIDES.left, half_bite_size, ''));
                    
                default:
                    $.error('Invalid side "' + side + '".');
            }
        },
        
        getLineHeight: function (elem) {
                var floats = $(elem).css('float');
                if (floats !== 'none') {
                    $(elem).css('float', 'none');
                }
                var pos = $(elem).css('position');
                if (pos === 'absolute') {
                    $(elem).css('position', 'static');
                }
    
                var html = $(elem).html(),
                wrapper_id = 'line-height-test',
                line_height;
    
                /* Set the content to a small single character and wrap. */
                $(elem).html('i').wrap('<div id="' + wrapper_id + '" />');
    
                /* Calculate the line height by measuring the wrapper.*/
                line_height = $('#' + wrapper_id).innerHeight();
    
                /* Remove the wrapper and reset the content. */
                $(elem).html(html).css({ 'float': floats, 'position': pos }).unwrap();
    
                return line_height;
            }
    };

    utils.eatStr.cache = {};
    utils.eatStr.generateKey = function () {
        return Array.prototype.join.call(arguments, '');
    };
    
    $.fn.trunk8 = function (method) {
        if (methods[method]) {
            return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
        }
        else if (typeof method === 'object' || !method) {
            return methods.init.apply(this, arguments);
        }
        else {
            $.error('Method ' + method + ' does not exist on jQuery.trunk8');
        }
    };
    
    /* Default trunk8 settings. */
    $.fn.trunk8.defaults = {
        fill: '&hellip;',
        lines: 1,
        side: SIDES.right,
        tooltip: true,
        width: WIDTH.auto,
        parseHTML: false,
        onTruncate: function () {}
    };
}));




/*
* jquery-match-height 0.7.0 by @liabru
* http://brm.io/jquery-match-height/
* License MIT
*/
!function(t){"use strict";"function"==typeof define&&define.amd?define(["jquery"],t):"undefined"!=typeof module&&module.exports?module.exports=t(require("jquery")):t(jQuery)}(function(t){var e=-1,o=-1,i=function(t){return parseFloat(t)||0},a=function(e){var o=1,a=t(e),n=null,r=[];return a.each(function(){var e=t(this),a=e.offset().top-i(e.css("margin-top")),s=r.length>0?r[r.length-1]:null;null===s?r.push(e):Math.floor(Math.abs(n-a))<=o?r[r.length-1]=s.add(e):r.push(e),n=a}),r},n=function(e){var o={
byRow:!0,property:"height",target:null,remove:!1};return"object"==typeof e?t.extend(o,e):("boolean"==typeof e?o.byRow=e:"remove"===e&&(o.remove=!0),o)},r=t.fn.matchHeight=function(e){var o=n(e);if(o.remove){var i=this;return this.css(o.property,""),t.each(r._groups,function(t,e){e.elements=e.elements.not(i)}),this}return this.length<=1&&!o.target?this:(r._groups.push({elements:this,options:o}),r._apply(this,o),this)};r.version="0.7.0",r._groups=[],r._throttle=80,r._maintainScroll=!1,r._beforeUpdate=null,
r._afterUpdate=null,r._rows=a,r._parse=i,r._parseOptions=n,r._apply=function(e,o){var s=n(o),h=t(e),l=[h],c=t(window).scrollTop(),p=t("html").outerHeight(!0),d=h.parents().filter(":hidden");return d.each(function(){var e=t(this);e.data("style-cache",e.attr("style"))}),d.css("display","block"),s.byRow&&!s.target&&(h.each(function(){var e=t(this),o=e.css("display");"inline-block"!==o&&"flex"!==o&&"inline-flex"!==o&&(o="block"),e.data("style-cache",e.attr("style")),e.css({display:o,"padding-top":"0",
"padding-bottom":"0","margin-top":"0","margin-bottom":"0","border-top-width":"0","border-bottom-width":"0",height:"100px",overflow:"hidden"})}),l=a(h),h.each(function(){var e=t(this);e.attr("style",e.data("style-cache")||"")})),t.each(l,function(e,o){var a=t(o),n=0;if(s.target)n=s.target.outerHeight(!1);else{if(s.byRow&&a.length<=1)return void a.css(s.property,"");a.each(function(){var e=t(this),o=e.attr("style"),i=e.css("display");"inline-block"!==i&&"flex"!==i&&"inline-flex"!==i&&(i="block");var a={
display:i};a[s.property]="",e.css(a),e.outerHeight(!1)>n&&(n=e.outerHeight(!1)),o?e.attr("style",o):e.css("display","")})}a.each(function(){var e=t(this),o=0;s.target&&e.is(s.target)||("border-box"!==e.css("box-sizing")&&(o+=i(e.css("border-top-width"))+i(e.css("border-bottom-width")),o+=i(e.css("padding-top"))+i(e.css("padding-bottom"))),e.css(s.property,n-o+"px"))})}),d.each(function(){var e=t(this);e.attr("style",e.data("style-cache")||null)}),r._maintainScroll&&t(window).scrollTop(c/p*t("html").outerHeight(!0)),
this},r._applyDataApi=function(){var e={};t("[data-match-height], [data-mh]").each(function(){var o=t(this),i=o.attr("data-mh")||o.attr("data-match-height");i in e?e[i]=e[i].add(o):e[i]=o}),t.each(e,function(){this.matchHeight(!0)})};var s=function(e){r._beforeUpdate&&r._beforeUpdate(e,r._groups),t.each(r._groups,function(){r._apply(this.elements,this.options)}),r._afterUpdate&&r._afterUpdate(e,r._groups)};r._update=function(i,a){if(a&&"resize"===a.type){var n=t(window).width();if(n===e)return;e=n;
}i?-1===o&&(o=setTimeout(function(){s(a),o=-1},r._throttle)):s(a)},t(r._applyDataApi),t(window).bind("load",function(t){r._update(!1,t)}),t(window).bind("resize orientationchange",function(t){r._update(!0,t)})});


/*!
 * jQuery Cookie Plugin v1.3.1
 * https://github.com/carhartl/jquery-cookie
 *
 * Copyright 2013 Klaus Hartl
 * Released under the MIT license
 */
(function (factory) {
	if (typeof define === 'function' && define.amd) {
		// AMD. Register as anonymous module.
		define(['jquery'], factory);
	} else {
		// Browser globals.
		factory(jQuery);
	}
}(function ($) {

	var pluses = /\+/g;

	function raw(s) {
		return s;
	}

	function decoded(s) {
		return decodeURIComponent(s.replace(pluses, ' '));
	}

	function converted(s) {
		if (s.indexOf('"') === 0) {
			// This is a quoted cookie as according to RFC2068, unescape
			s = s.slice(1, -1).replace(/\\"/g, '"').replace(/\\\\/g, '\\');
		}
		try {
			return config.json ? JSON.parse(s) : s;
		} catch(er) {}
	}

	var config = $.cookie = function (key, value, options) {

		// write
		if (value !== undefined) {
			options = $.extend({}, config.defaults, options);

			if (typeof options.expires === 'number') {
				var days = options.expires, t = options.expires = new Date();
				t.setDate(t.getDate() + days);
			}

			value = config.json ? JSON.stringify(value) : String(value);

			return (document.cookie = [
				config.raw ? key : encodeURIComponent(key),
				'=',
				config.raw ? value : encodeURIComponent(value),
				options.expires ? '; expires=' + options.expires.toUTCString() : '', // use expires attribute, max-age is not supported by IE
				options.path    ? '; path=' + options.path : '',
				options.domain  ? '; domain=' + options.domain : '',
				options.secure  ? '; secure' : ''
			].join(''));
		}

		// read
		var decode = config.raw ? raw : decoded;
		var cookies = document.cookie.split('; ');
		var result = key ? undefined : {};
		for (var i = 0, l = cookies.length; i < l; i++) {
			var parts = cookies[i].split('=');
			var name = decode(parts.shift());
			var cookie = decode(parts.join('='));

			if (key && key === name) {
				result = converted(cookie);
				break;
			}

			if (!key) {
				result[name] = converted(cookie);
			}
		}

		return result;
	};

	config.defaults = {};

	$.removeCookie = function (key, options) {
		if ($.cookie(key) !== undefined) {
			// Must not alter options, thus extending a fresh object...
			$.cookie(key, '', $.extend({}, options, { expires: -1 }));
			return true;
		}
		return false;
	};

}));


/**
 *jquery.easeScroll
 */
$.fn.easeScroll = function(options) {
    ! function() {
        function e() {
            var e = !1;
            e && c("keydown", r), v.keyboardSupport && !e && u("keydown", r)
        }

        function t() {
            if (document.body) {
                var t = document.body,
                    o = document.documentElement,
                    n = window.innerHeight,
                    r = t.scrollHeight;
                if (S = document.compatMode.indexOf("CSS") >= 0 ? o : t, w = t, e(), x = !0, top != self) y = !0;
                else if (r > n && (t.offsetHeight <= n || o.offsetHeight <= n)) {
                    var a = !1,
                        i = function() {
                            a || o.scrollHeight == document.height || (a = !0, setTimeout(function() {
                                o.style.height = document.height + "px", a = !1
                            }, 100))
                        };
                    if (o.style.height = "auto", setTimeout(i, 10), S.offsetHeight <= n) {
                        var l = document.createElement("div");
                        l.style.clear = "both", t.appendChild(l)
                    }
                }
                v.fixedBackground || b || (t.style.backgroundAttachment = "scroll", o.style.backgroundAttachment = "scroll")
            }
        }

        function o(e, t, o, n) {
            if (n || (n = 1e3), d(t, o), 1 != v.accelerationMax) {
                var r = +new Date,
                    a = r - C;
                if (a < v.accelerationDelta) {
                    var i = (1 + 30 / a) / 2;
                    i > 1 && (i = Math.min(i, v.accelerationMax), t *= i, o *= i)
                }
                C = +new Date
            }
            if (M.push({
                x: t,
                y: o,
                lastX: 0 > t ? .99 : -.99,
                lastY: 0 > o ? .99 : -.99,
                start: +new Date
            }), !T) {
                var l = e === document.body,
                    u = function() {
                        for (var r = +new Date, a = 0, i = 0, c = 0; c < M.length; c++) {
                            var s = M[c],
                                d = r - s.start,
                                f = d >= v.animationTime,
                                h = f ? 1 : d / v.animationTime;
                            v.pulseAlgorithm && (h = p(h));
                            var m = s.x * h - s.lastX >> 0,
                                w = s.y * h - s.lastY >> 0;
                            a += m, i += w, s.lastX += m, s.lastY += w, f && (M.splice(c, 1), c--)
                        }
                        l ? window.scrollBy(a, i) : (a && (e.scrollLeft += a), i && (e.scrollTop += i)), t || o || (M = []), M.length ? E(u, e, n / v.frameRate + 1) : T = !1
                    };
                E(u, e, 0), T = !0
            }
        }

        function n(e) {
            x || t();
            var n = e.target,
                r = l(n);
            if (!r || e.defaultPrevented || s(w, "embed") || s(n, "embed") && /\.pdf/i.test(n.src)) return !0;
            var a = e.wheelDeltaX || 0,
                i = e.wheelDeltaY || 0;
            return a || i || (i = e.wheelDelta || 0), !v.touchpadSupport && f(i) ? !0 : (Math.abs(a) > 1.2 && (a *= v.stepSize / 120), Math.abs(i) > 1.2 && (i *= v.stepSize / 120), o(r, -a, -i), void e.preventDefault())
        }

        function r(e) {
            var t = e.target,
                n = e.ctrlKey || e.altKey || e.metaKey || e.shiftKey && e.keyCode !== H.spacebar;
            if (/input|textarea|select|embed/i.test(t.nodeName) || t.isContentEditable || e.defaultPrevented || n) return !0;
            if (s(t, "button") && e.keyCode === H.spacebar) return !0;
            var r, a = 0,
                i = 0,
                u = l(w),
                c = u.clientHeight;
            switch (u == document.body && (c = window.innerHeight), e.keyCode) {
                case H.up:
                    i = -v.arrowScroll;
                    break;
                case H.down:
                    i = v.arrowScroll;
                    break;
                case H.spacebar:
                    r = e.shiftKey ? 1 : -1, i = -r * c * .9;
                    break;
                case H.pageup:
                    i = .9 * -c;
                    break;
                case H.pagedown:
                    i = .9 * c;
                    break;
                case H.home:
                    i = -u.scrollTop;
                    break;
                case H.end:
                    var d = u.scrollHeight - u.scrollTop - c;
                    i = d > 0 ? d + 10 : 0;
                    break;
                case H.left:
                    a = -v.arrowScroll;
                    break;
                case H.right:
                    a = v.arrowScroll;
                    break;
                default:
                    return !0
            }
            o(u, a, i), e.preventDefault()
        }

        function a(e) {
            w = e.target
        }

        function i(e, t) {
            for (var o = e.length; o--;) z[N(e[o])] = t;
            return t
        }

        function l(e) {
            var t = [],
                o = S.scrollHeight;
            do {
                var n = z[N(e)];
                if (n) return i(t, n);
                if (t.push(e), o === e.scrollHeight) {
                    if (!y || S.clientHeight + 10 < o) return i(t, document.body)
                } else if (e.clientHeight + 10 < e.scrollHeight && (overflow = getComputedStyle(e, "").getPropertyValue("overflow-y"), "scroll" === overflow || "auto" === overflow)) return i(t, e)
            } while (e = e.parentNode)
        }

        function u(e, t, o) {
            window.addEventListener(e, t, o || !1)
        }

        function c(e, t, o) {
            window.removeEventListener(e, t, o || !1)
        }

        function s(e, t) {
            return (e.nodeName || "").toLowerCase() === t.toLowerCase()
        }

        function d(e, t) {
            e = e > 0 ? 1 : -1, t = t > 0 ? 1 : -1, (k.x !== e || k.y !== t) && (k.x = e, k.y = t, M = [], C = 0)
        }

        function f(e) {
            if (e) {
                e = Math.abs(e), D.push(e), D.shift(), clearTimeout(A);
                var t = D[0] == D[1] && D[1] == D[2],
                    o = h(D[0], 120) && h(D[1], 120) && h(D[2], 120);
                return !(t || o)
            }
        }

        function h(e, t) {
            return Math.floor(e / t) == e / t
        }

        function m(e) {
            var t, o, n;
            return e *= v.pulseScale, 1 > e ? t = e - (1 - Math.exp(-e)) : (o = Math.exp(-1), e -= 1, n = 1 - Math.exp(-e), t = o + n * (1 - o)), t * v.pulseNormalize
        }

        function p(e) {
            return e >= 1 ? 1 : 0 >= e ? 0 : (1 == v.pulseNormalize && (v.pulseNormalize /= m(1)), m(e))
        }

        var settings = $.extend({
            // These are the defaults.
            frameRate: 60,
            animationTime: 1000,
            stepSize: 120,
            pulseAlgorithm: !0,
            pulseScale: 8,
            pulseNormalize: 1,
            accelerationDelta: 20,
            accelerationMax: 1,
            keyboardSupport: !0,
            arrowScroll: 50,
            touchpadSupport: !0,
            fixedBackground: !0
        }, options );

        var w, g = {
            frameRate: settings.frameRate,
            animationTime: settings.animationTime,
            stepSize: settings.stepSize,
            pulseAlgorithm: settings.pulseAlgorithm,
            pulseScale: settings.pulseScale,
            pulseNormalize: settings.pulseNormalize,
            accelerationDelta: settings.accelerationDelta,
            accelerationMax: settings.accelerationMax,
            keyboardSupport: settings.keyboardSupport,
            arrowScroll: settings.arrowScroll,
            touchpadSupport: settings.touchpadSupport,
            fixedBackground: settings.fixedBackground,
            excluded: ""
        },
            v = g,
            b = !1,
            y = !1,
            k = {
                x: 0,
                y: 0
            },
            x = !1,
            S = document.documentElement,
            D = [120, 120, 120],
            H = {
                left: 37,
                up: 38,
                right: 39,
                down: 40,
                spacebar: 32,
                pageup: 33,
                pagedown: 34,
                end: 35,
                home: 36
            },
            v = g,
            M = [],
            T = !1,
            C = +new Date,
            z = {};
        setInterval(function() {
            z = {}
        }, 1e4);
        var A, N = function() {
                var e = 0;
                return function(t) {
                    return t.uniqueID || (t.uniqueID = e++)
                }
            }(),
            E = function() {
                return window.requestAnimationFrame || window.webkitRequestAnimationFrame || function(e, t, o) {
                    window.setTimeout(e, o || 1e3 / 60)
                }
            }(),
            K = /chrome|iPad/i.test(window.navigator.userAgent),
            L = "onmousewheel" in document;
        L && K && (u("mousedown", a), u("mousewheel", n), u("load", t))
    }();
}




