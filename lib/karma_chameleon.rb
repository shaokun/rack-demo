require "rubygems"
require "nokogiri"
require "uri"

module Rack
  class KarmaChameleon
    def initialize(app, options = {})
      @ext = options[:extension] || "aspx"
      @ext_regexp = /\.#@ext$/
      @app = app
    end

    def call(env)
      if env["PATH_INFO"] =~ @ext_regexp || env["PATH_INFO"] == "/"
        env["PATH_INFO"] = remove_ext(env, env["PATH_INFO"])
        env["REQUEST_URI"] = remove_ext(env, env["REQUEST_URI"])

        status, headers, response = @app.call(env)

        if (300...400).include?(status) && headers["Location"]
          headers["Location"] = add_ext(env, headers["Location"])
        end

        if headers["Content-Type"] =~ /\bhtml\b/
          response = enhance_html(env, response)
          headers["Content-Length"] = response[0].size.to_s
        end

        [status, headers, response]
      else
        [404, {"Content-Type" => "text/html"}, ["Not Found"]]
      end
    end

    private

    def add_ext(env, path)
      uri = URI.parse(path)
      if uri.relative? || uri.host.casecmp(env["SERVER_NAME"]) && uri.port == env["SERVER_PORT"].to_i
        uri.path = uri.path.sub(/\/$/, "") + ".#@ext" unless uri.path == "/"
      end
      uri.to_s
    end

    def remove_ext(env, path)
      uri = URI.parse(path)
      uri.path = uri.path.sub(@ext_regexp, "/")
      uri.to_s
    end

    def enhance_html(env, response)
      body = ""
      response.each { |res| body += res }
      doc = Nokogiri::HTML(body)

      doc.css("a").each { |link| link["href"] = add_ext(env, link["href"]) if link["href"] }
      doc.css("form").each { |form| form["action"] = add_ext(env, form["action"]) if form["action"] }

      response = [doc.to_s]
    end
  end
end