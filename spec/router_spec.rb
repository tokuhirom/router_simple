require 'minitest/spec'
require 'minitest/autorun'

require 'router_simple'

describe RouterSimple::Router, '#xxx' do
    it 'returns nil when there is no registered pattern' do
        router = RouterSimple::Router.new()
        assert_equal router.match('GET', '/'), [nil, nil, false]
    end

    describe 'GET /' do
        it 'matches / when registered /' do
            router = RouterSimple::Router.new()
            router.register('GET', '/', 4)
            assert_equal router.match('GET', '/'), [4, {}]
        end

        it 'denides POST request' do
            router = RouterSimple::Router.new()
            router.register('GET', '/', 4)
            assert_equal router.match('POST', '/'), [nil, nil, true]
        end
    end

    it 'matches /json when registered /json' do
        router = RouterSimple::Router.new()
        router.register('GET', '/', 2)
        router.register('GET', '/json', 4)
        assert_equal router.match('GET', '/json'), [4, {}]
    end

    it 'matches /dankogai when registered /:name' do
        router = RouterSimple::Router.new()
        router.register('GET', '/:name', 4)
        assert_equal router.match('GET', '/dankogai'), [4, {'name' => 'dankogai'}]
    end

    it 'matches /dankogai/4 when registered /:name/:entry_id' do
        router = RouterSimple::Router.new()
        router.register('GET', '/:name/:entry_id', 4)
        assert_equal router.match('GET', '/dankogai/4'), [4, {'name' => 'dankogai', 'entry_id' => '4'}]
    end

    it 'does not match /dankogai/4 when registered /:name' do
        router = RouterSimple::Router.new()
        router.register('GET', '/:name', 4)
        assert_equal router.match('GET', '/dankogai/4'), [nil, nil, false]
    end

    it 'supports /foo/*name' do
        router = RouterSimple::Router.new()
        router.register('GET', '/foo/*name', 8)
        assert_equal router.match('GET', '/foo/jfsdlkaf/jajkdlsfj'), [8, {'name' => 'jfsdlkaf/jajkdlsfj'}]
    end
end
