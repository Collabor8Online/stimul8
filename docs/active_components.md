# Building an active component

These work the same way as [passive components](/docs/passive_components.md) but have a lot extra functionality.  To keep things brief, I'm going to ignore all the CSS stuff.  

Here's a simple card that represents a person.  

Firstly, let's look at our model: 

```ruby
class Person < ApplicationRecord
  include Stimul8::Model
  dispatch_events_on :update, :destroy 

  validates :name, presence: true
  validates :age, presence: true, numericality: { only_integer: true }
  has_one_attached :photo
end
```

And next, our card component:

```ruby
class MyApp::Person::CardComponent
  include Stimul8::ActiveComponent
  represents :person 
  render_if { context.can? :read, person }

  template do 
    c "my_app/card_component" do 
      slot :header do 
        person.name 
      end
      div do 
        img src: person.photo.url 
      end
      div style: "display: flex; justify-content: space-between" do 
        "Age"
        person.age 
      end
    end
  end
end
```

We then add this to our view: 

```erb
<%= c "my_app/person/card", context: current_user, person: @person %>
```

What has happened here?

* The Person model as well as being an ActiveRecord model, is also a Stimul8::Model.  It has been told to dispatch an event on every update or when it's destroyed.  
* Our new card component `represents :person`.  This ties it to our Person model.  
* The card component renders conditionally. The `render_if` declaration controls whether the component actually appears on the page - if the call returns true (or truthy) then the component is rendered, otherwise it is skipped.  Incidentally, the actual declaration is using a [CanCanCan](https://github.com/CanCanCommunity/cancancan)-style rule, but you can use anything you want to represent your authorisation system.

Then we draw out our template.  

We're reusing the Card component from the [passive component](/docs/passive_components.md) - so the call to `c` loads up that component.  We fill it's `:header` slot with the person's name and the main contents with the photo and the person's age.  

When we render the view, again we use `c` to instantiate the component, giving it the person we're interested in and the context in which it is being drawn - in this case, on behalf of the `current_user`.

Beyond a short-cut for accessing the Person model and a neat trick to stop us revealing classified information, what have we gained from this?

Well this component is now reactive.  Whenever the person model is updated, whether by this user or any other, an event will be dispatched to all the person model's dependents - including this component.  So the component will automatically redraw - just like Hotwire's `turbo_stream` broadcasts.  

As things stand, this hasn't gained us much - it's just an alternative syntax. 

But the real benefits come when you've got lots of components representing a person.  You might have a person-card, a person-list-item, a person-profile-badge, a live-people-aged-25-report, a person-wants-to-buy-something-but-can-only-buy-if-they-are-over-18-button.  It's a bit of a contrived example, as it's not likely that someone's name or age will change that often, but I'm sure you can imagine circumstances where frequent updates and multiple related views are required.  

In fact, I built this because in [Collabor8Online](https://www.collabor8online.co.uk) we display hundreds of folders containing many documents.  These folders are browsed, moved, renamed (and their documents uploaded, moved or revised) by hundreds of users concurrently.  There are over 100 different views (initially partials backed by TurboStreams, now being migrated over to components) involved in displaying these.  That's a lot of `broadcasts_updates_later_to` and partials to maintain.  With Stimul8, all it takes is either `represents :folder` or `represents :document` and the relevant components are refreshed automatically.

