# Stimul8

All the advantages of client-side components, with minimal Javascript plus server-side rendering

* Design your user-interface from discrete components, each representing one small aspect of your application.  
* Reuse common interface patterns and encapsulate styles.  
* Automatically refresh the relevant parts of the page when an underlying model changes, without keeping track of all the dependencies yourself.
* Build interactive components, with event handling and client-side properties, with all the advantages of server-side rendering within Rails.  
* [Markaby!](https://en.wikipedia.org/wiki/Why_the_lucky_stiff)

## Why does this exist?

* Because traditional [Ruby on Rails](https://rubyonrails.org), with its pure HTTP Request/Response cycle, whilst simple, won't cut it as users expect interactivity and reactivity
* Because [Hotwire](https://hotwired.dev) (which was inspirational when I first used it) is great for adding pieces of interactivity and reactivity to your Rails app.  But it's hard to track your dependencies (when I update these models, can I be certain that I've updated every element on every page for everyone that needs to see those changes?).  
* Because [ViewComponents](https://viewcomponent.org) are great for dividing your user-interface into small pieces, but you still need Javascript for interactivity and Hotwire for reactivity.  And the internals of ViewComponents are quite complex and I struggled to add the functionality I wanted into them.  
* Because full-stack Javascript frameworks make the things that Rails struggles with incredibly easy.  At the time of writing (2023), I'm particularly impressed with [Sveltekit](https://kit.svelte.dev).  But I don't want to write Javascript, as I'm a Rubyist at heart ([chunky bacon](http://poignant.guide/book/chapter-1.html)!).  

My aim is to: 
* Make the systems I'm building for [my day job](https://www.collabor8online.co.uk) simpler and easier to maintain.
* Make it simple to build front-end components in ruby
* Make it simple for front-end components to access and store state - both server-side and shared data (such as models) and client-side, session-specific data (such as whether a particular item is selected or highlighted) - without having to write lots of Javascript
* Make it simple for front-end components to react to changes in their dependencies (such as the models from which they get their data) without having to do a ton of work to keep track of those dependencies
* Reduce the complexity of the Rails routes file.  There is not a 1:1 correspondence between resources and models and there is rarely an easy mapping between HTTP verbs and the operations you want to perform on those models.  RESTful resources are fantastic, but sometimes you're actually making Remote Procedure Calls.  

## Usage

To get started check out the [glossary](/docs/glossary.md) and take a look at the [component lifecycle](/docs/lifecycle.md).

Then: 
* Open your Rails app
* Add the gem to your Gemfile and `bundle``
* [Configure](/docs/configuration.md) the gem to meet your needs
* Create an `app/components` folder (or whatever you want to call it)
* [Build your first component](/docs/passive_components.md)!

## Installation

Add this line to your application's Gemfile:

```ruby
gem "stimul8"
```

And then execute:
```bash
$ bundle
```

## To-Do List

- [X] Rename model stuff to represents as it reads better
- [ ] Finish off Actions
  - [ ] Basic implementation
  - [ ] Authorisation
  - [ ] Reactions - redraw, reload, redirect, animations, events
- [ ] Active and Passive components
- [ ] Add support for slots
- [ ] Morphdom
- [ ] Get stylesheet generation working properly (and rewrite the `styles` stuff as it's ugly)
- [ ] Reactive Event handling 
  - [ ] From model changes
  - [ ] From descendant components
- [ ] General Event handling
- [ ] Rails Cache and Redis storage engines
- [ ] Templates
  - [ ] Replace Markaby with [Phlex](https://www.phlex.fun)
  - [ ] ERB and other template engines
- [ ] Custom elements - replace Stimulus with generated custom elements?

## Contributing

Number One Rule - be nice.  We're all human beings, which means we're soft, squishy, emotional and sometimes illogical.  Plus we often have too much to do and have bad days where the rest of the world gets on top of us.  A little courtesy and compassion go a long way.  

### Issues and Bug Reports and Feature Requests

Use the [Github Issue Tracker](https://github.com/Collabor8Online/stimul8/issues) and post a friendly message explaining what you are looking for, where the gem currently falls short and, if you're able, some suggestions on how to get there.  

### Writing code

Fork the project.
Write some [RSpec](https://rspec.info) that explains what you're intentions are and documents how they work.  
Write some code that implements those intentions.  
Create a pull request and add a nice message to help me understand what you're trying to achieve and why it's important.  

## License

The gem is available as open source under the terms of the [GNU Lesser General Public Licence](/LICENCE).  I Am Not A Lawyer but this means that you can freely use this code in your own projects, whether open-source or otherwise licenced.  However, any modifications that you make to _this_ code must also be released under the GNU LGPL Licence and made available to anyone who uses that code.  Ideally, if you make changes to this code and it looks like it will benefit everyone, I would appreciate a pull request so we could merge it in.  

The intention is this.  Your code is your code and you can do what you want with it.  However, even if you make changes to this gem, it is _not_ your code; it is the work of _every_ contributor. So use this gem and modify it if needed but make those changes available to others so we all benefit.  