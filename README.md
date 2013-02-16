##Example:
___

```javascript
define(function(require) {
  
  var Decor = require('Decor');

  function BookPresenter(book) {
    Decor.call(this, book);
    
    this.delegate('title', 'pages', /^find/);
  };

  BookPresenter.prototype = {

    titleAcronym: function() {
      this.title
        .split(' ')
        .map(function(word) { return word.charAt(0); }).
        .join('')
        .toUpperCase();
    },
    
    averageWordsPerPage: function() {
      return Math.round(this.pages
        .map(function(page) {
          return page.text.split(\s+).length;
        })
        .reduce(function(total, additional) {
          return total + additional;
        }) / this.pages().length);
    } 
  };

  bookModel = new Book({ 
    title: 'War and Peace', 
    pages: [ 
      { text: 'some words here' }, 
      { text: 'more words now' } 
    ],
    text: function() {
      return this.pages.reduce(function(words, page) {
        return words + ' ' + page.text;
      }, '');
    },
    findFirstWord: function() { return this.text().split(' ')[0] },
    findFirstChar: function() { return this.text().charAt(0); }
  });

  book = new BookPresenter(book);

  // book can access properties of its source, as well as its own methods
  book.title //=> 'War and Peace'
  book.titleAcronym() //=> 'WAP'
  book.averageWordsPerPage() //=> '3'

  // book has access to methods that match regexp
  book.findFirstWord() //=> 'some'

  // book sets source property, using custom setter
  book.title = 'War, what is it good for?';
  bookModel.title //=> 'War, what is it good for?')

  // book gets source property, using custom getter
  bookModel.title = 'Another Title';
  book.title //=> 'Another Title';
