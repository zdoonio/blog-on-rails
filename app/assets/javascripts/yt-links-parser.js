(function ($) {

    $.fn.ytLinksParseToImage = function(options) {
        var settings = $.extend({
            width: 480,
            height: 270,
            darken: true,
            zoom: true
        }, options);

        var thumbnailClass = 'yt-links-parser-thumbnail';
        if (settings.darken) {
            thumbnailClass += ' yt-links-parser-darken';
        }
        if (settings.zoom) {
            thumbnailClass += ' yt-links-parser-zoom';
        }
        settings.replaceHtml = '<div class="yt-links-parser-container" data-yt-code="##CODE##" style="width:##WIDTH##px;height:##HEIGHT##px"><div class="' + thumbnailClass + '" style="background-image:url(\'https://i.ytimg.com/vi/##CODE##/hqdefault.jpg\');width:##WIDTH##px;height:##HEIGHT##px"></div><div class="yt-links-parser-play"></div></div>';

        return this.ytLinksParse(settings).find('.yt-links-parser-container').off('click.play').on('click.play', function() {
            var el = jQuery(this);
            var w = el.width();
            var h = el.height();
            var code = el.attr('data-yt-code');
            el.replaceWith('<iframe width="' + w + '" height="' + h + '" src="//www.youtube.com/embed/' + code + '?autoplay=1" frameborder="0" allowfullscreen></iframe>');
            return false;
        });
    };

    $.fn.ytLinksParse = function(options) {

        var settings = $.extend({
            width: 480,
            height: 270,
            replaceHtml: '<iframe width="##WIDTH##" height="##HEIGHT##" src="//www.youtube.com/embed/##CODE##" frameborder="0" allowfullscreen></iframe>'
        }, options);

        var invalidMatchesBeginnings = ['src=', 'value=', 'href='];

        function getReplaceHtml(code, options) {
            var width = options.width ? options.width : settings.width;
            var height = options.height ? options.height : settings.height;

            return settings.replaceHtml.replace(/##WIDTH##/g, width).replace(/##HEIGHT##/g, height).replace(/##CODE##/g, code);
        }

        function isFalsePositive(match) {
            for (var i = 0; i < invalidMatchesBeginnings.length; i++) {
                if (match.substring(0, invalidMatchesBeginnings[i].length) == invalidMatchesBeginnings[i]) {
                    return true;
                }
            }
            return false;
        }

        function replaceMatches(matches, html, options) {
            var newHtml = '';
            var offset = 0;

            for (var i = 0; i < matches.length; i++) {
                var match = matches[i];
                newHtml += html.slice(offset, match.offset) + getReplaceHtml(match.videoCode, options);
                offset = match.offset + match.length;
            }
            newHtml += html.slice(offset, html.length);

            return newHtml;
        }

        function geYtHost(match) {
            var host = match.split('/');
            if (host.length < 2) {
                return '';
            }
            return host[0];
        }

        function getVideoCode(match) {
            match = removeProtocol(match);

            var host = geYtHost(match);
            match = removeHost(match, host);

            if (!host || !match) {
                return '';
            }

            if (host.replace('www.', '') == 'youtu.be') {
                return getYoutuBeCode(match);
            }

            var matchArray = match.split('/');

            if (matchArray.length > 1) {
                return getEmbedOrVCode(matchArray);
            }

            matchArray = match.split('?');
            if (matchArray[0] == 'watch' && matchArray.length > 1) {
                return getWatchCode(matchArray);
            }

            return '';
        }

        function removeProtocol(match) {
            return match.replace(/(https?:)?\/\//i, '');
        }

        function removeHost(match, host) {
            return match = match.replace(host+'/', '');
        }

        function getYoutuBeCode(match) {
            match = match.split('?');
            return match[0];
        }

        function getEmbedOrVCode(matchArray) {
            if (matchArray[0] = 'v' || matchArray[0] == 'embed') {
                matchArray = matchArray[1].split('?');
                return matchArray[0];
            }
            return '';
        }

        function getWatchCode(matchArray) {
            matchArray = matchArray[1].split('&');
            for (var i = 0; i < matchArray.length; i++) {
                var pair = matchArray[i].split('=');
                if (pair.length !=2) {
                    continue;
                }
                if (pair[0] == 'v') {
                    return pair[1];
                }
            }
            return '';
        }

        function removeEndingFromMatch(match) {
            var lastChar = match.charAt(match.length-1);

            if (lastChar.search(/[^a-z0-9\?\=\&\-\_]/gi) != -1) {
                match = match.substr(0, match.length-1);
            }
            return match;
        }

        function getElementOptions(jQueryElement) {
            var options = {};
            if (jQueryElement.data('yt-width')) {
                options.width = parseInt(jQueryElement.data('yt-width'));
            }
            if (jQueryElement.data('yt-height')) {
                options.height = parseInt(jQueryElement.data('yt-height'));
            }
            return options;
        }

        return this.toArray().reverse().reduce(function(collection, element) {
            var jQueryElement = $(element);

            var elementOptions = getElementOptions(jQueryElement);
            var html = jQueryElement.html();
            var pattern = /(href=['"]?|src=['"]?|value=['"]?)?((https?:)?\/\/){0,1}(www.youtube.com|youtu.be)\/(.+?)([^a-z0-9\?\=\&\-\_]|$)/gi;

            var matches = [];
            var result = true;
            while(result = pattern.exec(html)) {
                var match = removeEndingFromMatch(result[0]);

                if (isFalsePositive(match)) {
                    continue;
                }

                var videoCode = getVideoCode(match);
                if (videoCode) {
                    matches.push({videoCode: videoCode, offset: result['index'], length: match.length});
                }
            }
            html = replaceMatches(matches, html, elementOptions);
            jQueryElement.html(html);
            return collection.add(jQueryElement);
        }, $());
    };
}(jQuery));
