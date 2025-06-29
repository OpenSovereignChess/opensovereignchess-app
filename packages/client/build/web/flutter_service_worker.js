'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"manifest.json": "54055e393c8f17c8875fb6f1a9196cc0",
"flutter_bootstrap.js": "186fb904c31eb1cd2cab739911dc17c9",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"icons/Icon-512.png": "013777f91f0a41d24921a7e32d264a75",
"icons/Icon-maskable-192.png": "ca0c6733ad9a9cdcbb3faaa30ee64a45",
"icons/Icon-maskable-512.png": "7d8fc5e3cf06d9e15b1cfd397644a861",
"icons/Icon-192.png": "03039e2dfdf6747d40b6353b9dd28ac3",
"favicon.png": "a7f92d607cb9322a1169c760e2ed1b8f",
"index.html": "ce2d728e4e4d2c2f1cc2cad0d4832789",
"/": "ce2d728e4e4d2c2f1cc2cad0d4832789",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/NOTICES": "f5cf7df1c423388a1819a0f8f6586da5",
"assets/AssetManifest.json": "5264d693c0ceeccfbeec9f826a273a5c",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "840747e128ec68320a354c77a9bb9ee2",
"assets/assets/piece_sets/wikimedia/pR.svg.vec": "035ca3e11ce377deb8b58d990992ec85",
"assets/assets/piece_sets/wikimedia/bQ.svg.vec": "6672d2160f10aede5f1896c4c3fd7f6a",
"assets/assets/piece_sets/wikimedia/aR.svg.vec": "9396e49d542fcc968613cbdea85c3417",
"assets/assets/piece_sets/wikimedia/vN.svg.vec": "3f43b7889c8b13043e07152f315d469b",
"assets/assets/piece_sets/wikimedia/gK.svg.vec": "161fd8be357d1414735420de192c3f7f",
"assets/assets/piece_sets/wikimedia/oB.svg.vec": "90599fe0aad258f42371780ed64d6883",
"assets/assets/piece_sets/wikimedia/pN.svg.vec": "9e70b42557282755408db9472858e22c",
"assets/assets/piece_sets/wikimedia/vP.svg.vec": "57d579ac841c4f7dacdcebb3b3a0062c",
"assets/assets/piece_sets/wikimedia/bB.svg.vec": "0553bd2b1d45b1c233247725cb3f8a24",
"assets/assets/piece_sets/wikimedia/gP.svg.vec": "bcdda03350bf945ea4caab0b1f9075bb",
"assets/assets/piece_sets/wikimedia/sN.svg.vec": "9da5f2e505d91e313b5bdfec3be99db6",
"assets/assets/piece_sets/wikimedia/cN.svg.vec": "eec79a144288a7a494268d43e72d4d13",
"assets/assets/piece_sets/wikimedia/nN.svg.vec": "78d949f5235a9a7ba59e6a84c14c4705",
"assets/assets/piece_sets/wikimedia/bP.svg.vec": "57c9be02bc67b15c3a7e0de7736f85e7",
"assets/assets/piece_sets/wikimedia/gR.svg.vec": "bd0cadc2af962ead4993292dcd6df18e",
"assets/assets/piece_sets/wikimedia/rQ.svg.vec": "5abb583919b2dd470250800db3a6df39",
"assets/assets/piece_sets/wikimedia/yN.svg.vec": "dee763efa5924f030384c4d238831d16",
"assets/assets/piece_sets/wikimedia/aB.svg.vec": "36c1433cb002ca6bc335701f33714178",
"assets/assets/piece_sets/wikimedia/cK.svg.vec": "0cd3d5cc7145a1f61cf6ebdc407c2a8a",
"assets/assets/piece_sets/wikimedia/nB.svg.vec": "aa7f2480b7c816beed0d4f3a0cea3f7a",
"assets/assets/piece_sets/wikimedia/rB.svg.vec": "27e21a22efe4715b7739d44011783148",
"assets/assets/piece_sets/wikimedia/vQ.svg.vec": "90d7c70b8b0df964224b4aa7d47f869d",
"assets/assets/piece_sets/wikimedia/pP.svg.vec": "5934cf363a0308ed1bf83a62d50b650c",
"assets/assets/piece_sets/wikimedia/rR.svg.vec": "853889085319407d96f0e5f4127de1af",
"assets/assets/piece_sets/wikimedia/rP.svg.vec": "b650b53c3f59a1cfbf3574f874436dbc",
"assets/assets/piece_sets/wikimedia/oQ.svg.vec": "be5ea7eaaf98c6d9a2827a5d5e72131d",
"assets/assets/piece_sets/wikimedia/bN.svg.vec": "0b45c48877f87ad6f952e799c595ad80",
"assets/assets/piece_sets/wikimedia/cB.svg.vec": "1f216af8f6578ad477aa56d4fd47725e",
"assets/assets/piece_sets/wikimedia/wN.svg.vec": "b485e53be550de26ffb2fdf47a5729c9",
"assets/assets/piece_sets/wikimedia/gQ.svg.vec": "3e7de35acfa445e499060cae1f339c0e",
"assets/assets/piece_sets/wikimedia/oK.svg.vec": "43d2eac0f6cfc9a4690265ff226ca9f1",
"assets/assets/piece_sets/wikimedia/pB.svg.vec": "e9c4a8e7e8a795f285ee5e17064ba36c",
"assets/assets/piece_sets/wikimedia/vR.svg.vec": "f564e02e98d5c4bf1c2e908fdec71a40",
"assets/assets/piece_sets/wikimedia/yK.svg.vec": "7c0bcf41f22fa54df8093862c9dd53f2",
"assets/assets/piece_sets/wikimedia/bK.svg.vec": "55ba9baaf533927f1fed764fec3dec9c",
"assets/assets/piece_sets/wikimedia/bR.svg.vec": "728c77a2edd462f859e0a132b6693891",
"assets/assets/piece_sets/wikimedia/sK.svg.vec": "3451330be77eab447ded15b9f264ea04",
"assets/assets/piece_sets/wikimedia/yP.svg.vec": "5ca08327c50f65278ea1a366d483a3a9",
"assets/assets/piece_sets/wikimedia/yB.svg.vec": "366e179afe4cd3316645ad874f9ef80f",
"assets/assets/piece_sets/wikimedia/vB.svg.vec": "a7ce41b149bc83c0b4fb9679fb67bd74",
"assets/assets/piece_sets/wikimedia/cP.svg.vec": "d3b9242bab1e5140d74a454729ea58f2",
"assets/assets/piece_sets/wikimedia/nP.svg.vec": "c079b09272865abc1a00ba02479f87ae",
"assets/assets/piece_sets/wikimedia/rN.svg.vec": "d986b59147f9232b79b444ddb39cc29c",
"assets/assets/piece_sets/wikimedia/nK.svg.vec": "aefa6655f86197524b97a8e7eed9a438",
"assets/assets/piece_sets/wikimedia/nR.svg.vec": "d64773e99ccdf1c6a10ea3f99e625897",
"assets/assets/piece_sets/wikimedia/sB.svg.vec": "bb3b504fbe8a09cb5be45303363f3395",
"assets/assets/piece_sets/wikimedia/pK.svg.vec": "c03e907b308ad07f5fdf8b26993ae950",
"assets/assets/piece_sets/wikimedia/wB.svg.vec": "55245fc576e720ceae4d235d0fb9b8e4",
"assets/assets/piece_sets/wikimedia/oN.svg.vec": "30c97e703d3a75e62aecfc19bdab3704",
"assets/assets/piece_sets/wikimedia/oR.svg.vec": "56dfbba58137a3a41ad232402b258601",
"assets/assets/piece_sets/wikimedia/sQ.svg.vec": "b0a3f14a7a40fd3ec8cda25d999631a2",
"assets/assets/piece_sets/wikimedia/pQ.svg.vec": "530186adacad2beef8e1ab19cfcd3f5e",
"assets/assets/piece_sets/wikimedia/aK.svg.vec": "d500ff355c7b8b9bff9b1b20df9584e3",
"assets/assets/piece_sets/wikimedia/aN.svg.vec": "a52ff8f989af9c750c77cb587d71cd6a",
"assets/assets/piece_sets/wikimedia/rK.svg.vec": "05e08ec685b25cf0ae265fbd963e1e22",
"assets/assets/piece_sets/wikimedia/gB.svg.vec": "7be7c33fb7641d76aa656d343d3c14ac",
"assets/assets/piece_sets/wikimedia/yR.svg.vec": "a6f38117082cb992a6af711c4cefa385",
"assets/assets/piece_sets/wikimedia/cR.svg.vec": "2a93535c498a0fd4705aad222135f7aa",
"assets/assets/piece_sets/wikimedia/wR.svg.vec": "86d322940bf67fc7e92cd071cbe20cc6",
"assets/assets/piece_sets/wikimedia/vK.svg.vec": "515ebb42d4ddacced637a509ffe164e1",
"assets/assets/piece_sets/wikimedia/wQ.svg.vec": "cdd119769027c46f8d8989543ef520cf",
"assets/assets/piece_sets/wikimedia/cQ.svg.vec": "e83d056db4099e58b94c5459da6532cc",
"assets/assets/piece_sets/wikimedia/gN.svg.vec": "0ba3fe120bbe0b10e352c1a7d5404b6e",
"assets/assets/piece_sets/wikimedia/wP.svg.vec": "afb6c3058efd244c9174281cb1af71fd",
"assets/assets/piece_sets/wikimedia/oP.svg.vec": "d87b298f0235be61ecd782f584b90957",
"assets/assets/piece_sets/wikimedia/nQ.svg.vec": "93d31b23a99512bcab4179053581d6bb",
"assets/assets/piece_sets/wikimedia/wK.svg.vec": "2ffd4172a09859f117118aa717ae8989",
"assets/assets/piece_sets/wikimedia/sP.svg.vec": "3a984ce85bc48d36c48f7c5f77cdace2",
"assets/assets/piece_sets/wikimedia/aQ.svg.vec": "23f6f9a2eb34c4c38adc849bd4ff0ec3",
"assets/assets/piece_sets/wikimedia/sR.svg.vec": "9cc45f336e0372e5bfabcc2ed01a0106",
"assets/assets/piece_sets/wikimedia/aP.svg.vec": "4568f0ca8181dfff1d8391c6a0b20f6e",
"assets/assets/piece_sets/wikimedia/yQ.svg.vec": "a430e319af5e4fdf36deefc939487d3c",
"assets/AssetManifest.bin.json": "b234b4d4b29c3a740999ef627e862198",
"assets/fonts/MaterialIcons-Regular.otf": "02c9a7eeca61e87c00d26bac6b8010a0",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin": "761baf9cb7fbc12f2c95ecdbf0f5c3d8",
"main.dart.js": "cb236d38445efdd8dfc8a08990c1fd1f",
"version.json": "e1bcae20bf39bfb9cd9be2a4c15dfc93"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
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
        // Claim client to enable caching on first launch
        self.clients.claim();
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
      // Claim client to enable caching on first launch
      self.clients.claim();
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
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
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
