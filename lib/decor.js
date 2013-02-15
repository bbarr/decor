define(function() {

  var extend = function(d, s) { for (var k in s) d[k] = s[k]; };

  function Decor(source) {

    this.source = source;

    // if being used as functional mixin, add prototype manually
    if (!(this instanceof Decor)) {
      extend(this, Decor.prototype)
    }
  };

  Decor.prototype = {

    // here to help coffeescript inheritance
    constructor: Decor,
    
    delegate: function() {

      var args = [].slice.call(arguments);
      var source = this.source;

      for (var i = 0, name, len = args.length; i < len; i++) {
        name = args[i];
        this[name] = function() { source[name].apply(source, arguments); };
      }
    }
  };

  return Decor;
});

