require 'erb'
require 'active_support/inflector'
require_relative 'params'
require_relative 'session'
require 'active_support/core_ext'

class ControllerBase
  attr_reader :params, :req, :res

  # setup the controller
  def initialize(req, res, route_params = {})
    @req = req
    @res = res

    @already_built_response = false

    #@res.body = @req.body
    # @session = Session.new(@req)
    @params = Params.new(@req, route_params)
  end

  # populate the response with content
  # set the responses content type to the given type
  # later raise an error if the developer tries to double render
  def render_content(content, type)
    raise "Already rendered" if already_rendered?
    @res.body = content
    @res.content_type = type

    session.store_session(@res)
    @already_built_response = true
    nil
  end

  def already_rendered?
    @already_built_response
  end

  # set the response status code and header
  def redirect_to(url)
    raise "Already rendered" if already_rendered?
    @res.status = 302
    @res.header['location'] = url
    session.store_session(@res)

    @already_built_response = true
    nil
  end



  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    template_fname =
      File.join("views", self.class.name.underscore, "#{template_name}.html.erb")
    render_content(
      ERB.new(File.read(template_fname)).result(binding),
      "text/html"
    )
  end

  def underscore(camel_cased_word)
    camel_cased_word.to_s.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
  end

  def session
    @session ||= Session.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    self.send(name)
    render(name) unless already_rendered?

    nil
  end

  # def render_content(content, type)
  # end
end
