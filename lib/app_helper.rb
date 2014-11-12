module AppHelper

  def cookie(key)
    cookies = request.headers['Cookie'] or return ''
    pattern = /#{key}=(.*?)(\;|$)/

    if cookies
      match = cookies.match(pattern)
      match ? match[1] : ''
    end
  end

  def current_user
    @current_user ||= User.find(email: cookie('email')).first
  end

  def logged_in?
    mystery = if cookie('mystery').empty?
      false
    else
      BCrypt::Password.new(cookie('mystery'))
    end

    if current_user && mystery == "#{current_user.email}#{current_user.password_hash}"
      true
    else
      false
    end
  end

  def render(file_name, args = {})
    Tilt::HamlTemplate.new("app/views/#{file_name}.haml").render(args)
  end

  def set_content_type
    responder.headers['Content-Type'] = case params[:path]
      when /\.js$/
        'application/javascript'
      when /\.css$/
        'text/css'
    end
  end

  def asset_path(path)
    dir = path =~ /(libraries|images)/ ? 'app/assets' : 'build'
    "#{dir}/#{path}"
  end

  def successful_login
    user = User.find(email: params['email']).first
    if user && user.login(params['password'])
      yield user
    end
  end

  def self.included(base)
    # misc routes
    base.get '/assets/(?<path>.*)', type: :regexp do
      set_content_type
      File.read(asset_path(params[:path]))
    end
  end

end
