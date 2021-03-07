'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/AssetManifest.json": "889461aa784feb07f4788217a9b41cc6",
"assets/assets/fonts/byekan/BYEKAN.TTF": "2a570d6f375cd1011a83b2cde93210a3",
"assets/assets/fonts/opensans/OpenSans-Regular.ttf": "3ed9575dcc488c3e3a5bd66620bdf5a4",
"assets/assets/images/Avatar.png": "17c9805ca70415608f9929d1b52bc8f4",
"assets/assets/images/avatarPlaceholder.png": "4736402c763d8cd003b22408c95e4776",
"assets/assets/images/back.jpg": "b0e9ac6055a80e1cac3a4e5d63fd2356",
"assets/assets/images/Drizzle.png": "2a6f3dcd5983ddd1fe45b02a93d1c47a",
"assets/assets/images/imgPlaceholder.png": "d5dc8a64bb7df0b088d6de475feb2c69",
"assets/assets/images/iranFlag.png": "e93acc6e4f1a407db9262f631fc447e5",
"assets/assets/images/meaning_intro_vector.png": "3e78d4398e7694d90727f241b5e189f4",
"assets/assets/images/Mostly%2520Cloudy.png": "668566c4cd4592f7aa90fca0800b07b8",
"assets/assets/images/Mostly%2520Sunny.png": "57dc9b88ad26426a8381dbb2673314c6",
"assets/assets/images/Party%2520Cloudy.png": "c6b7f8dcf9156e387b70f386d85b9c05",
"assets/assets/images/Sleet.png": "da8d2409de2a38d7410cee3eea609ef4",
"assets/assets/images/Titile_Logo_Mark.png": "4a67f9c66c0fdb0a75b44da8c7747a7e",
"assets/assets/images/Titile_Logo_Mark_dark.png": "52fa4b2777b3bdbe7934211afceb5d37",
"assets/assets/images/Titile_Logo_Mark_light.png": "4a67f9c66c0fdb0a75b44da8c7747a7e",
"assets/assets/lottie/36236-sun-icon.json": "2e7831a54edd91036ba5aa1ff131610c",
"assets/assets/lottie/biometric-sign-in.json": "78b593ce7f94132daa483ac5d591d897",
"assets/assets/lottie/cameraOption.json": "231e45fbefea66d2202a8d05c014611e",
"assets/assets/lottie/checkLogin.json": "5cf4c3337ffe79746d3e6bda709c645f",
"assets/assets/lottie/darkModeLottie.json": "4609766c3c441441fa7adeed743ea74b",
"assets/assets/lottie/datePick.json": "82ec79ccb4513332d1a29e6a7c0574af",
"assets/assets/lottie/gelleryOption.json": "bb5791532a87aee3b7646b20a31bf44b",
"assets/assets/lottie/loadingUserPlate.json": "f9da22d1716b71b58c039ab3d86c6b5c",
"assets/assets/lottie/reserve_dark.json": "1c094cdcf454516d46e5df9f5f55cbf3",
"assets/assets/lottie/reserve_light.json": "1c094cdcf454516d46e5df9f5f55cbf3",
"assets/assets/lottie/searching.json": "697eb0311a019210b851ebce2206540a",
"assets/assets/lottie/timePick.json": "57b0688dcb043da6af7d1582e4ede22c",
"assets/assets/lottie/userPlates.json": "46bdf62b0366a265cf1247c4680ab089",
"assets/FontManifest.json": "3627e40503156ecdc63f5b1f7dbf0437",
"assets/fonts/MaterialIcons-Regular.otf": "1288c9e28052e028aba623321f7826ac",
"assets/NOTICES": "7608fb4e5e389b686e89eecf7e221642",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/packages/rflutter_alert/assets/images/2.0x/close.png": "abaa692ee4fa94f76ad099a7a437bd4f",
"assets/packages/rflutter_alert/assets/images/2.0x/icon_error.png": "2da9704815c606109493d8af19999a65",
"assets/packages/rflutter_alert/assets/images/2.0x/icon_info.png": "612ea65413e042e3df408a8548cefe71",
"assets/packages/rflutter_alert/assets/images/2.0x/icon_success.png": "7d6abdd1b85e78df76b2837996749a43",
"assets/packages/rflutter_alert/assets/images/2.0x/icon_warning.png": "e4606e6910d7c48132912eb818e3a55f",
"assets/packages/rflutter_alert/assets/images/3.0x/close.png": "98d2de9ca72dc92b1c9a2835a7464a8c",
"assets/packages/rflutter_alert/assets/images/3.0x/icon_error.png": "15ca57e31f94cadd75d8e2b2098239bd",
"assets/packages/rflutter_alert/assets/images/3.0x/icon_info.png": "e68e8527c1eb78949351a6582469fe55",
"assets/packages/rflutter_alert/assets/images/3.0x/icon_success.png": "1c04416085cc343b99d1544a723c7e62",
"assets/packages/rflutter_alert/assets/images/3.0x/icon_warning.png": "e5f369189faa13e7586459afbe4ffab9",
"assets/packages/rflutter_alert/assets/images/close.png": "13c168d8841fcaba94ee91e8adc3617f",
"assets/packages/rflutter_alert/assets/images/icon_error.png": "f2b71a724964b51ac26239413e73f787",
"assets/packages/rflutter_alert/assets/images/icon_info.png": "3f71f68cae4d420cecbf996f37b0763c",
"assets/packages/rflutter_alert/assets/images/icon_success.png": "8bb472ce3c765f567aa3f28915c1a8f4",
"assets/packages/rflutter_alert/assets/images/icon_warning.png": "ccfc1396d29de3ac730da38a8ab20098",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"index.html": "7c9b5c59647de2cd710db7d011f8dd67",
"/": "7c9b5c59647de2cd710db7d011f8dd67",
"main.dart.js": "091bae9c8ededbafe7ae114dbb0b242b",
"manifest.json": "262d961b07082fa6b0d29d1bbb23bbc9",
"version.json": "0ec582fc4fc293d99a01184b6759b44d"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value + '?revision=' + RESOURCES[value], {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
