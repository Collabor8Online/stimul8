# Building a passive component

A passive component is one that is not reactive or interactive.  They are useful as the building-blocks of your user-interface - those common elements that you reuse everywhere and would like to have a consistent style and appearance.  

Let's build a "card" component that we can reuse everywhere - although the CSS will need a fair bit of improving!

## Using a Markaby template

Create a new component: 

```ruby
class MyApp::CardComponent
  include Stimul8::PassiveComponent

  style "&", "border: var(--card-border-width) solid var(--card-border-color)";
  style "&", "background-color: var(--card-background-color)";
  style ".header", "background-color: var(--card-header-background-color)";
  style ".header", "background-color: var(--card-header-text-color)";
  style ".footer", "background-color: var(--card-footer-background-color)";
  style ".footer", "background-color: var(--card-footer-text-color)";

  slot :header 
  slot :footer

  template do 
    if has_contents_for? :header 
      div class: "header" do 
        contents_for :header 
      end
    end
    div class: "contents" do 
      contents 
    end
    if has_contents_for? :footer
      div class: "footer" do 
        contents_for :footer
      end
    end
  end
end
```

Then open one of your views and add in: 

```erb
<h1>My new card component</h1>
<%= c "my_app/card" do %>
  <% slot :header do %>
    This is the header
  <% end %>
  Hello Card!
  <% slot :footer do %>
    This is the footer
  <% end %>
<% end %>
```

When you view your page, you should see something along these lines:

```html
<h1>My new card component</h1>
<div id="some-really-long-identifier" class="my-app--card-component">
  <div class="header">
    This is the header
  </div>
  <div class="contents">
    Hello Card!
  </div>
  <div class="footer">
    This is the footer
  </div>
</div>
```

## Using an ERB template

Don't like Markaby?  You can use a traditional ERB template instead.

Coming soon