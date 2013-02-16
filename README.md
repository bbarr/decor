##Example:
___

```javascript
define(function(require) {
  
  var Decor = require('Decor');

  function BookPresenter(book) {
    Decor.call(this, book);
    
    this.delegate('title', 'pages');
  };

  BookPresenter.prototype = {

    titleAcronym: function() {
      this.title()
        .split(' ')
        .map(function(word) { return word.charAt(0); }).
        .join('')
        .toUpperCase();
    },
    
    averageWordsPerPage: function() {
      return Math.round(this.pages()
        .map(function(page) {
          return page.text.split(\s+).length;
        })
        .reduce(function(total, additional) {
          return total + additional;
        }) / this.pages().length);
    } 
  };

  bookModel = new Book({ title: 'War and Peace', pages: [ { text: 'some words here' }, { text: 'more words now' } ] })
  book = new BookPresenter(book)

  book.title() => 'War and Peace'
  book.titleAcronym() => 'WAP'
  book.averageWordsPerPage() => '3'

  book.title('War, what is it good for?')
  bookModel.title() => 'War, what is it good for?')
