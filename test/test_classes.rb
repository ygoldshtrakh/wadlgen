require 'test/unit'
require 'wadlgen'

class TestClasses < Test::Unit::TestCase

  def test_application
    base = "http://www.example.com/"
    app = Wadlgen::Application.new
  end

  def test_resources
    base = "http://www.example.com/"
    path = "resources"
    app = Wadlgen::Application.new()
    res = app.add_resources(base).add_resource(nil, path)
    assert_equal 1, app.resources.resources.length
    assert_equal res, app.resources.resources.first
    assert_equal app.resources, res.parent
    assert_equal path, res.path
  end

  def test_has_resource
    base = "http://www.example.com/"
    path = "resources"
    app = Wadlgen::Application.new()
    resources = app.add_resources(base)
    res = resources.add_resource(nil, path)
    res2 = resources.add_resource(nil, 'applications')
    assert resources.has_resource? nil, path
    assert resources.has_resource? nil, 'applications'
    assert !resources.has_resource?(nil, 'something')
  end

  def test_get_resource
    base = "http://www.example.com/"
    path = "resources"
    app = Wadlgen::Application.new()
    resources = app.add_resources(base)
    res = resources.add_resource(nil, path)
    res2 = resources.add_resource(nil, 'applications')
    assert_equal res2, resources.get_resource(nil, 'applications')
    res3 = resources.get_resource(nil, 'users')
    assert_equal 'users', res3.path
    assert_equal resources, res3.parent
  end

  def test_methods
    base = "http://www.example.com/"
    path = "resources"
    app = Wadlgen::Application.new
    res = app.add_resources(base).add_resource(nil, path)
    method = res.add_method('GET', 'resource')
    assert_equal res, method.parent
    assert_equal 1, res.methods.length
    assert_equal method, res.methods.first
    assert_equal 'GET', method.name
    assert_equal 'resource', method.id
  end

  def test_has_method
    base = "http://www.example.com/"
    path = "resources"
    app = Wadlgen::Application.new
    res = app.add_resources(base).add_resource(nil, path)
    res.add_method('GET', 'resource')
    res.add_method('POST', 'resource')
    assert res.has_method? 'GET', 'resource'
    assert res.has_method? 'POST', 'resource'
    assert !res.has_method?('GET', 'something')
    assert !res.has_method?('PUT', 'resource')
    assert !res.has_method?('POST', 'something')
  end

  def test_get_method
    base = "http://www.example.com/"
    path = "resources"
    app = Wadlgen::Application.new
    res = app.add_resources(base).add_resource(nil, path)
    m1 = res.add_method('GET', 'resource')
    m2 = res.add_method('POST', 'resource')
    assert_equal m1, res.get_method('GET', 'resource')
    assert_equal m2, res.get_method('POST', 'resource')
    m3 = res.get_method('GET', 'user')
    assert_equal res, m3.parent
  end

  def test_response
    base = "http://www.example.com/"
    path = "resources"
    app = Wadlgen::Application.new
    res = app.add_resources(base).add_resource(nil, path)
    method = res.add_method('GET', 'resource')
    response = method.add_response(200)
    assert_equal 200, response.status
    assert_equal method, response.method
    assert_equal 1, method.responses.length
    assert_equal response, method.responses.first
  end

  def test_representation
    base = "http://www.example.com/"
    path = "resources"
    app = Wadlgen::Application.new
    res = app.add_resources(base).add_resource(nil, path)
    method = res.add_method('GET', 'resource')
    response = method.add_response(200)
    repr = response.add_representation("application/xml", "xml")
    assert_equal "xml", repr.element
    assert_equal "application/xml", repr.media_type
    assert_equal response, repr.parent
    assert_equal 1, response.representations.length
    assert_equal repr, response.representations.first
  end

  def test_request
    base = "http://www.example.com/"
    path = "resources"
    app = Wadlgen::Application.new
    res = app.add_resources(base).add_resource(nil, path)
    method = res.add_method('GET', 'resource')
    request = method.add_request
    assert_equal method, request.method
    assert_equal request, method.request
  end

  def test_parameter
    base = "http://www.example.com/"
    path = "resources"
    app = Wadlgen::Application.new
    res = app.add_resources(base).add_resource(nil, path)
    method = res.add_method('GET', 'resource')
    request = method.add_request
    param = request.add_param("id", "query")
    assert_equal 'id', param.name
    assert_equal 'query', param.style
    assert_equal request, param.parent
    assert_equal 1, request.params.length
    assert_equal param, request.params.first
  end


  def test_parameter_options
    base = "http://www.example.com/"
    path = "resources"
    app = Wadlgen::Application.new
    res = app.add_resources(base).add_resource(nil, path)
    method = res.add_method('GET', 'resource')
    request = method.add_request
    param = request.add_param("id", "query")
    opt = param.add_option('xml', 'application/xml')
    assert_equal 'xml', opt.value
    assert_equal 'application/xml', opt.media_type
    assert_equal param, opt.parameter
    assert_equal 1, param.options.length
    assert_equal opt, param.options.first
  end

end
