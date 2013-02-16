define(function() {

  var SLICE = Array.prototype.slice;
  var extend = function(d, s) { for (var k in s) d[k] || (d[k] = s[k]); };

  function Decor(source) {

    this.source = source;
    this.source_keys = Object.keys(source);

    // if being used as functional mixin, add prototype manually
    if (!(this instanceof Decor)) {
      extend(this, Decor.prototype)
    }
  };

  Decor.prototype = {

    // here to help coffeescript inheritance
    constructor: Decor,
    
    delegate: function() {
      var source = this.source;
      SLICE.call(arguments).forEach(function(name) {
        if (typeof name === 'string') {
          this._delegateByString(name);
        } else if (typeof name.test !== 'undefined') {
          this._delegateByRegExp(name);
        }
      }, this);
    },

    _delegateByString: function(name) {
      var source = this.source;
      if (typeof source[name] === 'function') {
        this[name] = function() {
          return source[name].apply(source, arguments);
        };
      } else {
        this.__defineGetter__(name, function() { return source[name]; });
        this.__defineSetter__(name, function(v) { return source[name] = v; });
      }
    },

    _delegateByRegExp: function(re) {
      this.source_keys.forEach(function(m) {
        if (re.test(m)) this._delegateByString(m);
      }, this);
    }
  };

  return Decor;
});

