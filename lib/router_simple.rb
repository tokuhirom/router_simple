require "router_simple/version"

=begin

router_simple.rb - minimalistic path dispatcher

=head1 SYNOPSIS

    router = RouterSimple::Router.new
    router.register('GET',  '/', 'Root')
    router.register('POST', '/member/create', 'Member#create')
    router.register('GET',  '/member/:name', 'Member#detail')
    router.register('GET',  '/download/*path', 'Download#detail')

    router.match('/')
    # => ('Root', {})

    router.match('/member/dankogai')
    # => ('Member#detail', {"name" => 'dankogai'})

    router.match('/download/growthforecast')
    # => ('Download#detail', {"path" => 'growthforecast'})

=end

module RouterSimple
    class Router
        # Create new instance
        def initialize
            @patterns = []
        end

        # register a path to router.
        #
        # @param [Araray or String] http_method HTTP method. You can specify nil, ['GET', 'HEAD"], 'GET', etc.
        # @param [String] path
        # @param [Any]    dest Destination of this path
        # @return None
        def register(http_method, path, dest)
            @patterns.push(Route.new(http_method, path, dest))
        end

        # match the path with this router.
        #
        # @param [String] http_method REQUEST_METHOD
        # @param [String] path        PATH_INFO
        #
        # @return dest destination info
        # @return captured captured parameters
        # @return method_not_allowed true if method not allowed.
        def match(http_method, path)
            found_method_not_allowed = false
            @patterns.each do |pattern|
                dest, captured, method_not_allowed = pattern.match(http_method, path)
                if dest
                    return dest, captured
                elsif method_not_allowed
                    found_method_not_allowed = true
                end
            end
            return nil, nil, found_method_not_allowed
        end
    end

    class Route
        # Create new route object
        #
        # @param [Araray or String or NilClass] http_method HTTP method. You can specify nil, ['GET', 'HEAD"], 'GET', etc.
        # @param [String] path
        # @param [Any]    dest Destination of this path
        def initialize(http_method, path, data)
            @path = path
            @pattern = compile(path)
            @data = data
            @http_method = http_method.is_a?(String) ? [http_method] : http_method
        end

        # Match to this route
        # 
        # @param [String] http_method REQUEST_METHOD
        # @param [String] path        PATH_INFO
        #
        # @return dest               Destination for this route
        # @return captures           captured parameters by router
        # @return method_not_allowed True if the route was denied by method.
        def match(http_method, path)
            matched = @pattern.match(path)
            if matched
                if @http_method && !@http_method.any? {|m| m==http_method}
                    return nil, nil, true
                end
                captures = {}
                matched.names.zip(matched.captures).each {|x|
                    captures[x[0]] = x[1]
                }
                return @data, captures
            else
                return nil, nil
            end
        end

        # compile 'path' pattern to regexp.
        def compile(path)
            if path.kind_of?(Regexp)
                return path
            else
                pattern = Regexp.compile(
                    '\A' + (
                    path.gsub(/[-\[\]{}()+?.,\\^$|#\s]/) {|x|
                        Regexp.escape(x)
                    }
                    .gsub(/:([\w\d]+)/, "(?<\\1>[^\/]+)")
                    .gsub(/\*([\w\d]+)/, "(?<\\1>.+?)")
                    ) + '\z'
                )
                pattern
            end
        end
    end
end


