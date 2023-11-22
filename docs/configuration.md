# Configuration

## During client-server communication

When the component is rendered on the client's page, it opens a web-socket connection back to the server.  This connection is then used to open channels, so the component can send actions to and receive updates and notifications from the server.  The connection needs to know the context that the component is operating in so it can ensure that messages are routed correctly.  

In order to do this you set the `Stimul8::CableConnection` context loader.  This is given the current request and cookies, which should be enough to identify the context.  

For example, if your context represents the current user and you use an authentication system like Devise (where the current user ID is stored in a session cookie), your context loader could look like this: 

```ruby
Stimul8::CableConnection.load_context_from do |request, cookies|
  User.find cookies.signed[:session][:person_id]
end
```

Maybe your application is multi-tenant and you need to know which account you are currently working with, in addition to the current user.  In this case, you could represent the context as a Hash and your context loader might look like this: 

```ruby
Stimul8::CableConnection.load_context_from do |request, cookies|
  { 
    account: Account.find_by!(subdomain: request.subdomain), 
    user: User.find( cookies.signed[:session][:person_id])
  }
end
```