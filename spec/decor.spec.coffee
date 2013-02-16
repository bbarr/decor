require [ 'lib/decor.js' ], (Decor) ->

  obj = {}
  decorated = null
  acts_as_decor = ->

    describe '#delegate', ->

      it 'should handle a string', ->
        spyOn(decorated, '_delegateByString')
        decorated.delegate('name')
        expect(decorated._delegateByString).toHaveBeenCalledWith('name')

      it 'should handle a regexp', ->
        spyOn(decorated, '_delegateByRegExp')
        decorated.delegate(/foo/)
        expect(decorated._delegateByRegExp).toHaveBeenCalledWith(/foo/)
      
      it 'should work on multiple arguments as method names', ->
        spyOn(decorated, '_delegateByString')
        decorated.delegate('name', 'desc')
        expect(decorated._delegateByString.callCount).toBe(2)

    describe '#_delegateByString', ->

      describe 'a string that references a function', ->

        it 'should copy method to itself', ->
          expect(decorated.name).not.toBeDefined()
          decorated.delegate('name')
          expect(typeof decorated.name).toBe('function')

        it 'should bind the method to source', ->
          decorated.delegate('name')
          spyOn(obj, 'name')
          decorated.name()
          expect(obj.name).toHaveBeenCalled()

      describe 'a string that references a non-function', ->

    describe '#_delegateByRegExp', ->

      it 'should call #_delegateByString for any source key that matches regex', ->
        spyOn(decorated, '_delegateByString')
        decorated._delegateByRegExp(/foo/)
        expect(decorated._delegateByString.callCount).toBe(3)


  describe 'Decor', ->
    
    beforeEach ->
      obj =
        name: ((data) -> if data then @_name = data else @_name)
        desc: ((data) -> if data then @_desc = data else @_desc)
        foo_bar: (->)
        foo_bat: (->)
        foo_baz: (->)

    describe 'as simple constructor', ->

      beforeEach ->
        decorated = new Decor(obj)

      describe 'basic functionality', acts_as_decor

    describe 'as coffeescript class', ->

      ObjPresenter = null
      beforeEach ->
        class ObjPresenter extends Decor

          constructor: ->
            super

          another_method: ->

        decorated = new ObjPresenter(obj)

      describe 'basic functionality', acts_as_decor

      it 'should have extended methods', ->
        expect(decorated.another_method).toBeDefined()

    describe 'as functional mixin', ->
      
      beforeEach ->
        ObjPresenter = (obj) ->
          Decor.call(@, obj)

        ObjPresenter.prototype =
          another_method: ->
        
        decorated = new ObjPresenter(obj)

      describe 'basic functionality', acts_as_decor

      it 'should have extended methods', ->
        expect(decorated.another_method).toBeDefined()
