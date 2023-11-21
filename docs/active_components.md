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

* The Person model as well as being an ActiveRecord model, is also a Stimul8::Model, which dispatches events on every update or if it's destroyed.  
* Our new card component `represents :person`.  This ties it to our Person model.  
* The card component will only `render_if { context.can? :read, person }`.  This is using a [CanCanCan](https://github.com/CanCanCommunity/cancancan)-style rule to check if the context (in this case, our `current_user`, as we'll see below) has permission to read this person.  If not, then nothing will be rendered onto the page.  (Of course, you can use whatever authorisation system you want to check for permission here).

Then we draw out our template.  

We're reusing the Card component from the [passive component](/docs/passive_components.md) - so the call to `c` loads up that component.  We fill it's `:header` slot with the person's name and the main contents with the photo and the person's age.  

When we render the view, again we use `c` to instantiate the component, giving it the person we're interested in and the context in which it is being drawn - in this case, on behalf of the `current_user`.

Beyond a short-cut for accessing the Person model and a neat trick to stop us revealing classified information, what have we gained from this?

Well, now, any time someone else updates this particular Person record (`@person.update! age: (@person.age + 1)`) and event is dispatched to all the person's dependents.   If this `MyApp::Person::CardComponent` is visible on-screen somewhere, it will automatically redraw itself.  Just like Hotwire's `turbo_stream` broadcasts.  

As things stand, this hasn't gained us much - it's just an alternative syntax. 

The real benefit comes when you have lots of components that represent a person - a person-card, a person-list-item, a person-profile-badge, a live-people-aged-25-report, a person-wants-to-buy-something-but-can-only-buy-if-they-are-over-18-button.  OK - so basing updates on `age` might not require immediate updates.  But in [Collabor8Online](https://www.collabor8online.co.uk) we display folders containing documents and the folders are often moved or renamed, documents are regularly uploaded, moved or revised.  There are over 100 different components involved in displaying the folder and its contents which is a lot of `broadcasts_updates_later_to` and partials to maintain.  With Stimul8, all it takes is either `represents :folder` or `represents :document` and the relevant components are refreshed automatically.

