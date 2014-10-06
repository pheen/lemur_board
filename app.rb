require 'cuba'
require 'cuba/haml'
require 'ohm'
require 'byebug'

Cuba.plugin Cuba::Haml

Cuba.define do
  on root do
    haml('main')
  end

  on 'assets' do
    on /(.*libraries.*)/ do |path|
      set_content_type(path)
      res.write(File.read("app/assets/#{path}"))
    end

    on /(.*)/ do |path|
      set_content_type(path)
      res.write(File.read("build/#{path}"))
    end

  end

end

def set_content_type(path)
  res.headers["Content-Type"] = case path
    when /javascripts/
      'application/javascript'
    when /stylesheets/
      'text/css'
  end
end
