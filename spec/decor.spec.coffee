require [ 'lib/decor.js' ], (Decor) ->

  obj = {}
  decorated = null
  acts_as_decor = ->

    describe '#delegate', ->
      
      it 'should copy method to itself', ->
        expect(decorated.name).not.toBeDefined()
        decorated.delegate('name')
        expect(typeof decorated.name).toBe('function')

      it 'should bind the method to source', ->
        decorated.delegate('name')
        spyOn(obj, 'name')
        decorated.name()
        expect(obj.name).toHaveBeenCalled()

      it 'should work on multiple arguments as method names', ->
        decorated.delegate('name', 'desc')
        expect(decorated.name).toBeDefined()
        expect(decorated.desc).toBeDefined()

  describe 'Decor', ->
    
    beforeEach ->
      obj =
        name: ((data) -> if data then @_name = data else @_name)
        desc: ((data) -> if data then @_desc = data else @_desc)

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
