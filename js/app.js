"use strict";

$(document).ready(function() {
  var playing = false;
  var sources = [];

  var context = new AudioContext;
  var currNdx = 0;
  //var names = ["days", "donttrip", "friend", "listeni", "whatday", "wheel", "wth"];

  var nextName = function() {
    //return names[currNdx++ % names.length];
    return names[Math.floor(Math.random() * names.length)];
  };

  var get = function(out) {
    var source = context.createBufferSource();
    sources.push(source);

    var req = new XMLHttpRequest();

    req.open("GET", "./" + nextName() + ".wav", true);

    req.responseType = "arraybuffer";

    req.onload = function() {
      context.decodeAudioData(req.response, function(buffer) {
        source.buffer = buffer;
        source.loop   = false;

        source.connect(context.destination);
        
        source.onended = function() {
          if(playing) get();
        };

        source.start(0);
      });
    }

    req.send();
  };

  $("#start").click(function() {
    playing = true;

    get();
    get();
  });

  $("#stop").click(function() {
    playing = false;

    sources.forEach(function(node) {
      node.stop();
    });
    sources = [];
  });
});
