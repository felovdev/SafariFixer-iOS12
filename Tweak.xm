#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

static NSString * const SFFixerScript = @"
(function() {
    if (window.__safariFixerInstalled) return;
    window.__safariFixerInstalled = true;

    function prepareVideo(video) {
        if (!(video instanceof HTMLVideoElement)) return;
        if (!video.hasAttribute('playsinline')) video.setAttribute('playsinline', '');
        if (!video.hasAttribute('webkit-playsinline')) video.setAttribute('webkit-playsinline', '');
    }

    function prepareVideos(root) {
        if (!root) return;
        if (root.nodeType === 1 && root.tagName === 'VIDEO') prepareVideo(root);
        if (root.querySelectorAll) {
            var videos = root.querySelectorAll('video');
            for (var i = 0; i < videos.length; i++) prepareVideo(videos[i]);
        }
    }

    function restoreFailedVideos() {
        var videos = document.querySelectorAll('video');
        for (var i = 0; i < videos.length; i++) {
            var video = videos[i];
            prepareVideo(video);
            // Retry only a video element that has a source and reports a media error.
            // Do not reload the whole page or replace a third-party iframe.
            if (video.error && (video.currentSrc || video.src)) {
                try { video.load(); } catch (e) {}
            }
        }
    }

    prepareVideos(document);

    if (window.MutationObserver && document.documentElement) {
        var observer = new MutationObserver(function(records) {
            for (var i = 0; i < records.length; i++) {
                var added = records[i].addedNodes;
                for (var j = 0; j < added.length; j++) prepareVideos(added[j]);
            }
        });
        observer.observe(document.documentElement, { childList: true, subtree: true });
    }

    window.addEventListener('pageshow', function(event) {
        if (event && event.persisted) window.setTimeout(restoreFailedVideos, 250);
    }, false);
})();
";

%hook WKWebView

- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration {
    if (configuration && configuration.userContentController) {
        @try {
            WKUserScript *script = [[WKUserScript alloc]
                initWithSource:SFFixerScript
                injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                forMainFrameOnly:NO];
            [configuration.userContentController addUserScript:script];
        } @catch (NSException *exception) {
            NSLog(@"[SafariFixer] Could not install page helper: %@", exception);
        }
    }
    return %orig(frame, configuration);
}

%end
