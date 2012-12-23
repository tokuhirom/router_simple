require 'minitest/spec'
require 'minitest/autorun'

require 'router_simple'

describe RouterSimple::Route, '#match' do
    describe 'GET /' do
        r = RouterSimple::Route.new('GET', '/', 4)

        it 'allows GET /' do
            assert_equal r.match('GET', '/'), [4, {}]
        end

        it 'denides POST' do
            assert_equal r.match('POST', '/'), [nil, nil, true]
        end

        it 'does not match to /foo' do
            assert_equal r.match('GET', '/foo'), [nil, nil]
        end
    end

    describe 'GET|HEAD /' do
        r = RouterSimple::Route.new(['GET', 'HEAD'], '/', 4)

        it 'allows GET /' do
            assert_equal r.match('GET', '/'), [4, {}]
        end

        it 'also allows HEAD /' do
            assert_equal r.match('HEAD', '/'), [4, {}]
        end

        it 'denides POST' do
            assert_equal r.match('POST', '/'), [nil, nil, true]
        end
    end

    describe 'GET /:name' do
        route = RouterSimple::Route.new('GET', '/:name', 8)

        it 'matches /dankogai' do
            assert_equal route.match('GET', '/dankogai'), [8, {'name' => 'dankogai'}]
        end

        it 'does not matches /dankogai/4' do
            assert_equal route.match('GET', '/dankogai/4'), [nil, nil]
        end
    end

    describe 'GET /:name/:entry_id' do
        router = RouterSimple::Route.new('GET', '/:name/:entry_id', 4)

        it 'matches /dankogai/4' do
            assert_equal router.match('GET', '/dankogai/4'), [4, {'name' => 'dankogai', 'entry_id' => '4'}]
        end

        it 'does not match /dankogai/' do
            assert_equal router.match('GET', '/dankogai/'), [nil, nil]
        end
    end

    describe 'GET /foo/*name' do
        it 'matches /foo/yappo' do
            router = RouterSimple::Route.new('GET', '/foo/*name', 8)
            assert_equal router.match('GET', '/foo/yappo'), [8, {'name' => 'yappo'}]
        end
    end

    describe 'use regexp as a path' do
        describe 'using named capture' do
            router = RouterSimple::Route.new('GET', %r{^/foo/(?<no>[0-9]+)$}, 8)
            it 'matches /foo/111' do
                assert_equal router.match('GET', '/foo/111'), [8, {'no' => '111'}]
            end
            it 'does not matches /foo/bar' do
                assert_equal router.match('GET', '/foo/bar'), [nil, nil]
            end
        end
        describe 'using paren capture' do
            router = RouterSimple::Route.new('GET', %r{^/foo/([0-9]+)$}, 8)
            it 'matches /foo/111' do
                assert_equal router.match('GET', '/foo/111'), [8, {}]
            end
            it 'does not matches /foo/bar' do
                assert_equal router.match('GET', '/foo/bar'), [nil, nil]
            end
        end
    end
end
