#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
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

    function retryNetworkFailedVideos() {
        var videos = document.querySelectorAll('video');
        for (var i = 0; i < videos.length; i++) {
            var video = videos[i];
            prepareVideo(video);

            // Retry a network error once. Unsupported codecs and decode errors
            // cannot be repaired by repeatedly calling load().
            if (video.error && video.error.code === 2 &&
                (video.currentSrc || video.src) &&
                !video.getAttribute('data-safarifixer-retried')) {
                video.setAttribute('data-safarifixer-retried', '1');
                try { video.load(); } catch (e) {}
            }
        }
    }

    prepareVideos(document);

    // Observe the Document itself: documentElement may not exist yet at
    // document-start, which is when this user script is injected.
    if (window.MutationObserver) {
        try {
            var observer = new MutationObserver(function(records) {
                for (var i = 0; i < records.length; i++) {
                    var added = records[i].addedNodes;
                    for (var j = 0; j < added.length; j++) prepareVideos(added[j]);
                }
            });
            observer.observe(document, { childList: true, subtree: true });
        } catch (e) {}
    }

    window.addEventListener('pageshow', function(event) {
        if (event && event.persisted) window.setTimeout(retryNetworkFailedVideos, 300);
    }, false);

    var wasHidden = document.visibilityState === 'hidden';
    document.addEventListener('visibilitychange', function() {
        if (document.visibilityState === 'hidden') {
            wasHidden = true;
        } else if (wasHidden) {
            wasHidden = false;
            window.setTimeout(retryNetworkFailedVideos, 300);
        }
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
            NSLog(@"[SafariFixer] Failed to register page helper: %@", exception);
        }
    }
    return %orig(frame, configuration);
}

%end
