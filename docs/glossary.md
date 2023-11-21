# Glossary

Things you might need to know.

## Component

A repeatable, interactive, reactive piece of functionality.  

## Templates

The way in which the component renders itself on the page.  

Currently, Stimul8 supports [Markaby](https://github.com/markaby/markaby), but the plan is to add in support for .erb templates (which should be familiar to all Rails programmers) and possibly [Phlex](https://www.phlex.fun) or a plugin template system.  

### Markaby

If you're not familiar with Markaby, it has an important place in Ruby history.  It was originally written by _why the lucky stiff, who also wrote the [Poignant Guide to Ruby](http://poignant.guide/book/chapter-1.html).  _why had a whimsical style and when I, like many others, read the Poignant Guide and had a play with Markaby, I knew I wanted to use Ruby for evermore.  

## Passive Component

A passive component is one that renders itself onto the page, but isn't interactive or reactive.  They are useful for building standard user-interface elements, and they have less overhead than an active component.  

## Active Component

An active component is interactive and/or reactive.  Interactive means it can respond to user input, updating itself or other aspects of the system.  Reactive means it redraws itself in response to external events - whether that's because a model was edited or because the component's internal state has changed.

## Context

All components are optionally rendered within a context.  This can be any object, but is generally used to represent the current user.  Generally, you set the context when the component is first rendered and it is reinstated when the client-side component communicates with the server.  See the [component lifecycle](/docs/lifecycle.md) for more on this.  

## State

### Component ID

### Properties

### Models

### Storage

## Interactivity

### Actions

### Reactions

## Reactivity

### Model Updates

### Event Handling



