RSpec.describe ShVars do
  subject { |e| described_class.parse(e.description) }

  let(:parse_error) { ShVars::ParseError }

  specify "FOO" do
    should eq [['FOO', ""]]
  end

  specify "FOO= BAR=bar" do
    should eq [['FOO', ""], ['BAR', 'bar']]
  end

  specify "FOO= BAR=" do
    should eq [['FOO', ""], ['BAR', '']]
  end

  specify 'FOO=foo=bar' do
    should eq [['FOO', 'foo=bar']]
  end

  specify 'FOO=foo BAR=bar BAZ=baz' do
    should eq [['FOO', 'foo'], ['BAR', 'bar'], ['BAZ', 'baz']]
  end

  specify 'FOO="foo foo" BAR="bar bar"' do
    should eq [['FOO', '"foo foo"'], ['BAR', '"bar bar"']]
  end

  specify %q(FOO=foo"bar"baz"buz") do
    should eq [['FOO', %q(foo"bar"baz"buz")]]
  end

  specify %q(FOO="foo"bar) do
    should eq [['FOO', %q("foo"bar)]]
  end

  specify %q(FOO='foo foo' BAR='bar bar') do
    should eq [['FOO', %q('foo foo')], ['BAR', %q('bar bar')]]
  end

  specify "FOO='foo foo' BAR=bar" do
    should eq [['FOO', "'foo foo'"], ['BAR', 'bar']]
  end

  specify "FOO=foo'bar'baz'buz'" do
    should eq [['FOO', "foo'bar'baz'buz'"]]
  end

  specify "FOO='foo'bar'baz'buz" do
    should eq [['FOO', "'foo'bar'baz'buz"]]
  end

  specify "FOO='foo''bar'" do
    should eq [['FOO', "'foo''bar'"]]
  end

  specify "FOO='foo foo' BAR='bar bar'" do
    should eq [['FOO', "'foo foo'"], ['BAR', "'bar bar'"]]
  end

  specify "FOO='foo foo' BAR=\"bar bar\"" do
    should eq [['FOO', "'foo foo'"], ['BAR', '"bar bar"']]
  end

  specify 'FOO="foo foo" BAR=bar' do
    should eq [['FOO', '"foo foo"'], ['BAR', 'bar']]
  end

  specify 'FOO="foo foo" BAR="bar bar"' do
    should eq [['FOO', '"foo foo"'], ['BAR', '"bar bar"']]
  end

  specify %q(FOO='"foo foo" foo' BAR='"bar bar" bar') do
    should eq [['FOO', %q('"foo foo" foo')], ['BAR', %q('"bar bar" bar')]]
  end

  specify %q(FOO="'foo foo' foo" BAR="'bar bar' bar") do
    should eq [['FOO', %q("'foo foo' foo")], ['BAR', %q("'bar bar' bar")]]
  end

  specify 'FOO=foo\"bar' do
    should eq [['FOO', 'foo\"bar']]
  end

  specify 'FOO="\"foo\" bar"' do
    should eq [['FOO', '"\"foo\" bar"']]
  end

  specify 'FOO="\"\\\"foo bar\\\"\" baz"' do
    should eq [['FOO', '"\"\\\"foo bar\\\"\" baz"']]
  end

  specify %q("FOO='foo'") do
    should eq [['FOO', %q('foo')]]
  end

  specify '"FOO=\"foo\""' do
    should eq [['FOO', '"foo"']]
  end

  specify '"FOO=\"\\\"foo\\\"\""' do
    should eq [['FOO', '"\"foo\""']]
  end

  specify '"FOO=\"\\\"\\\\\\\\"foo\\\\\\\\"\\\"\""' do
    should eq [['FOO', '"\"\\\"foo\\\"\""']]
  end

  specify '$var BAR="bar bar"' do
    should eq [['$var', ''], ['BAR', '"bar bar"']]
  end

  specify 'FOO=$var BAR="bar bar"' do
    should eq [['FOO', '$var'], ['BAR', '"bar bar"']]
  end

  specify 'FOO="$var" BAR="bar bar"' do
    should eq [['FOO', '"$var"'], ['BAR', '"bar bar"']]
  end

  specify 'FOO=$var bar BAR="bar bar"' do
    should eq [['FOO', '$var'], ['bar', ''], ['BAR', '"bar bar"']]
  end

  specify 'FOO=$ BAR="bar bar"' do
    should eq [['FOO', '$'], ['BAR', '"bar bar"']]
  end

  specify '`cmd`' do
    should eq [['`cmd`', '']]
  end

  specify 'foo`cmd`bar' do
    should eq [['foo`cmd`bar', '']]
  end

  specify 'FOO=`cmd`' do
    should eq [['FOO', '`cmd`']]
  end

  specify 'FOO=`"$(cmd -r)"`' do
    should eq [['FOO', '`"$(cmd -r)"`']]
  end

  specify 'FOO=foo`cmd`bar' do
    should eq [['FOO', 'foo`cmd`bar']]
  end

  specify '$(cmd)' do
    should eq [['$(cmd)', '']]
  end

  specify 'foo$(cmd)bar' do
    should eq [['foo$(cmd)bar', '']]
  end

  specify 'FOO=$(cmd)' do
    should eq [['FOO', '$(cmd)']]
  end

  specify 'FOO=$(cmd -r)' do
    should eq [['FOO', '$(cmd -r)']]
  end

  specify 'FOO=$(cmd $(cmd $(cmd -r)))' do
    should eq [['FOO', '$(cmd $(cmd $(cmd -r)))']]
  end

  specify 'FOO="$(cmd $(cmd $(cmd -r)))"' do
    should eq [['FOO', '"$(cmd $(cmd $(cmd -r)))"']]
  end

  specify 'FOO="$(cmd \"$(cmd $(cmd -r))\")"' do
    should eq [['FOO', '"$(cmd \"$(cmd $(cmd -r))\")"']]
  end

  specify 'FOO=$(`$(`cmd -r`)`)' do
    should eq [['FOO', '$(`$(`cmd -r`)`)']]
  end

  specify 'FOO=${var}' do
    should eq [['FOO', '${var}']]
  end

  specify 'FOO=${var}foo' do
    should eq [['FOO', '${var}foo']]
  end

  specify 'FOO="foo\\"bar"' do
    should eq [['FOO', '"foo\\"bar"']]
  end

  specify 'FOO=FOO:`cmd -r`bar' do
    should eq [['FOO', 'FOO:`cmd -r`bar']]
  end

  specify 'FOO=`cmd -r`' do
    should eq [['FOO', '`cmd -r`']]
  end

  specify 'FOO=foo`cmd -r`' do
    should eq [['FOO', 'foo`cmd -r`']]
  end

  specify 'FOO=foo$(cmd -r)' do
    should eq [['FOO', 'foo$(cmd -r)']]
  end

  specify 'FOO=foo$($(cmd -r))' do
    should eq [['FOO', 'foo$($(cmd -r))']]
  end

  specify 'FOO=foo$("$(cmd -r)")' do
    should eq [['FOO', 'foo$("$(cmd -r)")']]
  end

  specify 'FOO="$(FOO)"' do
    should eq [['FOO', '"$(FOO)"']]
  end

  specify 'FOO="$(\"${FOO}\")"' do
    should eq [['FOO', '"$(\\"${FOO}\\")"']]
  end

  specify 'FOO=foo"$(cmd \"${FOO}\" {} \;)"' do
    should eq [['FOO', 'foo"$(cmd \\"${FOO}\\" {} \\;)"']]
  end

  specify 'FOO=$(cmd foo)' do
    should eq [['FOO', '$(cmd foo)']]
  end

  specify 'FOO=http://$BAR:80' do
    should eq [['FOO', 'http://$BAR:80']]
  end

  specify %q(FOO=') do
    expect { subject }.to raise_error(parse_error)
  end

  specify 'FOO="' do
    expect { subject }.to raise_error(parse_error)
  end

  specify 'FOO="\"' do
    expect { subject }.to raise_error(parse_error)
  end

  specify 'FOO="\" ' do
    expect { subject }.to raise_error(parse_error)
  end

  specify 'FOO="\" BAR=bar' do
    expect { subject }.to raise_error(parse_error)
  end

  specify 'FOO=foo"bar' do
    expect { subject }.to raise_error(parse_error)
  end
end
