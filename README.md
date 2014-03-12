# Rails Lite
Project explores basic functionality of Rails.

## WEBRick
* Sets up WEBRick in `test/my_first_server.rb`

## Basic ControllerBase
* Provides us with some of the same functionality as `ActionController::Base` like `render` and `redirect_to`

## Template rendering
* `render(template_name)` method reads in template file, creates new ERB template from contents, uses `binding` to capture controller's instance variables, evaluates the ERB template, and passes contents to `render_content`

## Session
Uses WEBRick tos tore cookies. `Session` helper class looks for our cookie.
* `store_session(response)` creates new cookies to send back as response
* `Session#store_session` sets cookies in `redirect_to` and `render_content`

## Parameters

Query string parameters
* `parse_www_encoded_form` parses URI encoded string, setting keys and values in `@params` hash

Request body params
* Uses Regex to parase parameters uploaded to servers in request body, to "nest" hashes

## Routing
* `Route` stores URL pattern it's meant to match, HTTP method (GET, POST, PUT, DELETE), controller class route maps to, and action anme to be invoked.
* Implements `get`, `post`, `put`, and `delete` with `define_method`
* `Router#draw` takes block and uses `Object#instance_eval(&proc)` because it's equivalent to `obj.method`. The block of code should only be run in context of router.
* `ControllerBase#initialize` can take a `route_params` hash which is passed onto `Params::new(req, route_params)`. `Params` class then extends this hash with params from query string and request body.