RSpec.describe ShVars do
  subject { |e| described_class.parse(e.description) }

  let(:parse_error) { ShVars::ParseError }

  it "FOO" do
    should eq [['FOO', '']]
  end

  it "FOO= BAR=bar" do
    should eq [['FOO', ''], ['BAR', 'bar']]
  end

  it "FOO= BAR=" do
    should eq [['FOO', ''], ['BAR', '']]
  end

  it 'FOO=foo=bar' do
    should eq [['FOO', 'foo=bar']]
  end

  it 'FOO=foo BAR=bar BAZ=baz' do
    should eq [['FOO', 'foo'], ['BAR', 'bar'], ['BAZ', 'baz']]
  end

  it 'FOO="foo foo" BAR="bar bar"' do
    should eq [['FOO', '"foo foo"'], ['BAR', '"bar bar"']]
  end

  it %q(FOO=foo"bar"baz"buz") do
    should eq [['FOO', %q(foo"bar"baz"buz")]]
  end

  it %q(FOO="foo"bar) do
    should eq [['FOO', %q("foo"bar)]]
  end

  it %q(FOO='foo foo' BAR='bar bar') do
    should eq [['FOO', %q('foo foo')], ['BAR', %q('bar bar')]]
  end

  it "FOO='foo foo' BAR=bar" do
    should eq [['FOO', "'foo foo'"], ['BAR', 'bar']]
  end

  it "FOO=foo'bar'baz'buz'" do
    should eq [['FOO', "foo'bar'baz'buz'"]]
  end

  it "FOO='foo'bar'baz'buz" do
    should eq [['FOO', "'foo'bar'baz'buz"]]
  end

  it "FOO='foo''bar'" do
    should eq [['FOO', "'foo''bar'"]]
  end

  it "FOO='foo foo' BAR='bar bar'" do
    should eq [['FOO', "'foo foo'"], ['BAR', "'bar bar'"]]
  end

  it "FOO='foo foo' BAR=\"bar bar\"" do
    should eq [['FOO', "'foo foo'"], ['BAR', '"bar bar"']]
  end

  it 'FOO="foo foo" BAR=bar' do
    should eq [['FOO', '"foo foo"'], ['BAR', 'bar']]
  end

  it 'FOO="foo foo" BAR="bar bar"' do
    should eq [['FOO', '"foo foo"'], ['BAR', '"bar bar"']]
  end

  it %q(FOO='"foo foo" foo' BAR='"bar bar" bar') do
    should eq [['FOO', %q('"foo foo" foo')], ['BAR', %q('"bar bar" bar')]]
  end

  it %q(FOO="'foo foo' foo" BAR="'bar bar' bar") do
    should eq [['FOO', %q("'foo foo' foo")], ['BAR', %q("'bar bar' bar")]]
  end

  it 'FOO=foo\"bar' do
    should eq [['FOO', 'foo\"bar']]
  end

  it 'FOO="\"foo\" bar"' do
    should eq [['FOO', '"\"foo\" bar"']]
  end

  it 'FOO="\"\\\"foo bar\\\"\" baz"' do
    should eq [['FOO', '"\"\\\"foo bar\\\"\" baz"']]
  end

  it %q("FOO='foo'") do
    should eq [['FOO', %q('foo')]]
  end

  it '"FOO=\"foo\""' do
    should eq [['FOO', '"foo"']]
  end

  it '"FOO=\"\\\"foo\\\"\""' do
    should eq [['FOO', '"\"foo\""']]
  end

  it '"FOO=\"\\\"\\\\\\\\"foo\\\\\\\\"\\\"\""' do
    should eq [['FOO', '"\"\\\"foo\\\"\""']]
  end

  it '$var BAR="bar bar"' do
    should eq [['$var', ''], ['BAR', '"bar bar"']]
  end

  it 'FOO=$var BAR="bar bar"' do
    should eq [['FOO', '$var'], ['BAR', '"bar bar"']]
  end

  it 'FOO="$var" BAR="bar bar"' do
    should eq [['FOO', '"$var"'], ['BAR', '"bar bar"']]
  end

  it 'FOO=$var bar BAR="bar bar"' do
    should eq [['FOO', '$var'], ['bar', ''], ['BAR', '"bar bar"']]
  end

  it 'FOO=$ BAR="bar bar"' do
    should eq [['FOO', '$'], ['BAR', '"bar bar"']]
  end

  it '`cmd`' do
    should eq [['`cmd`', '']]
  end

  it 'foo`cmd`bar' do
    should eq [['foo`cmd`bar', '']]
  end

  it 'FOO=`cmd`' do
    should eq [['FOO', '`cmd`']]
  end

  it 'FOO=`"$(cmd -r)"`' do
    should eq [['FOO', '`"$(cmd -r)"`']]
  end

  it 'FOO=foo`cmd`bar' do
    should eq [['FOO', 'foo`cmd`bar']]
  end

  it '$(cmd)' do
    should eq [['$(cmd)', '']]
  end

  it 'foo$(cmd)bar' do
    should eq [['foo$(cmd)bar', '']]
  end

  it 'FOO=$(cmd)' do
    should eq [['FOO', '$(cmd)']]
  end

  it 'FOO=$(cmd -r)' do
    should eq [['FOO', '$(cmd -r)']]
  end

  it 'FOO=$(cmd $(cmd $(cmd -r)))' do
    should eq [['FOO', '$(cmd $(cmd $(cmd -r)))']]
  end

  it 'FOO="$(cmd $(cmd $(cmd -r)))"' do
    should eq [['FOO', '"$(cmd $(cmd $(cmd -r)))"']]
  end

  it 'FOO="$(cmd \"$(cmd $(cmd -r))\")"' do
    should eq [['FOO', '"$(cmd \"$(cmd $(cmd -r))\")"']]
  end

  it 'FOO=$(`$(`cmd -r`)`)' do
    should eq [['FOO', '$(`$(`cmd -r`)`)']]
  end

  it 'FOO=${var}' do
    should eq [['FOO', '${var}']]
  end

  it 'FOO=${var}foo' do
    should eq [['FOO', '${var}foo']]
  end

  it 'FOO="foo\\"bar"' do
    should eq [['FOO', '"foo\\"bar"']]
  end

  it 'FOO=FOO:`cmd -r`bar' do
    should eq [['FOO', 'FOO:`cmd -r`bar']]
  end

  it 'FOO=`cmd -r`' do
    should eq [['FOO', '`cmd -r`']]
  end

  it 'FOO=foo`cmd -r`' do
    should eq [['FOO', 'foo`cmd -r`']]
  end

  it 'FOO=foo$(cmd -r)' do
    should eq [['FOO', 'foo$(cmd -r)']]
  end

  it 'FOO=foo$($(cmd -r))' do
    should eq [['FOO', 'foo$($(cmd -r))']]
  end

  it 'FOO=foo$("$(cmd -r)")' do
    should eq [['FOO', 'foo$("$(cmd -r)")']]
  end

  it 'FOO="$(FOO)"' do
    should eq [['FOO', '"$(FOO)"']]
  end

  it 'FOO="$(\"${FOO}\")"' do
    should eq [['FOO', '"$(\\"${FOO}\\")"']]
  end

  it 'FOO=foo"$(cmd \"${FOO}\" {} \;)"' do
    should eq [['FOO', 'foo"$(cmd \\"${FOO}\\" {} \\;)"']]
  end

  it 'FOO=-foo$((1+${bar}))' do
    should eq [['FOO', '-foo$((1+${bar}))']]
  end

  it 'FOO=$(cmd foo)' do
    should eq [['FOO', '$(cmd foo)']]
  end

  it 'FOO=http://$BAR:80' do
    should eq [['FOO', 'http://$BAR:80']]
  end

  it 'FOO="\foo \bar"' do
    should eq [['FOO', '"\foo \bar"']]
  end

  it '= FOO' do
    expect { subject }.to raise_error(parse_error)
  end

  it '==FOO== FOO=foo' do
    expect { subject }.to raise_error(parse_error)
  end

  it %q(FOO=') do
    expect { subject }.to raise_error(parse_error)
  end

  it 'FOO="' do
    expect { subject }.to raise_error(parse_error)
  end

  it 'FOO="\"' do
    expect { subject }.to raise_error(parse_error)
  end

  it 'FOO="\" ' do
    expect { subject }.to raise_error(parse_error)
  end

  it 'FOO="\" BAR=bar' do
    expect { subject }.to raise_error(parse_error)
  end

  it 'FOO=foo"bar' do
    expect { subject }.to raise_error(parse_error)
  end
end
