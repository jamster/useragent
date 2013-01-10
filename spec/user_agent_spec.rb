require 'user_agent'
require 'ostruct'

describe BVUserAgent do
  it "should require a product" do
    lambda { BVUserAgent.new(nil) }.should raise_error(ArgumentError, "expected a value for product")
  end

  it "should split comment to an array if a string is passed in" do
    useragent = BVUserAgent.new("Mozilla", "5.0", "Macintosh; U; Intel Mac OS X 10_5_3; en-us")
    useragent.comment.should == ["Macintosh", "U", "Intel Mac OS X 10_5_3", "en-us"]
  end

  it "should set version to nil if it is blank" do
    BVUserAgent.new("Mozilla", "").version.should be_nil
  end

  it "should only output product when coerced to a string" do
    BVUserAgent.new("Mozilla").to_str.should == "Mozilla"
  end

  it "should output product and version when coerced to a string" do
    BVUserAgent.new("Mozilla", "5.0").to_str.should == "Mozilla/5.0"
  end

  it "should output product, version and comment when coerced to a string" do
    useragent = BVUserAgent.new("Mozilla", "5.0", ["Macintosh", "U", "Intel Mac OS X 10_5_3", "en-us"])
    useragent.to_str.should == "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_3; en-us)"
  end

  it "should output product and comment when coerced to a string" do
    useragent = BVUserAgent.new("Mozilla", nil, ["Macintosh"])
    useragent.to_str.should == "Mozilla (Macintosh)"
  end

  it "should be eql if both products are the same" do
    BVUserAgent.new("Mozilla").should eql(BVUserAgent.new("Mozilla"))
  end

  it "should not be eql if both products are the same" do
    BVUserAgent.new("Mozilla").should_not eql(BVUserAgent.new("Opera"))
  end

  it "should be eql if both products and versions are the same" do
    BVUserAgent.new("Mozilla", "5.0").should eql(BVUserAgent.new("Mozilla", "5.0"))
  end

  it "should not be eql if both products and versions are not the same" do
    BVUserAgent.new("Mozilla", "5.0").should_not eql(BVUserAgent.new("Mozilla", "4.0"))
  end

  it "should be eql if both products, versions and comments are the same" do
    BVUserAgent.new("Mozilla", "5.0", ["Macintosh"]).should eql(BVUserAgent.new("Mozilla", "5.0", ["Macintosh"]))
  end

  it "should not be eql if both products, versions and comments are not the same" do
    BVUserAgent.new("Mozilla", "5.0", ["Macintosh"]).should_not eql(BVUserAgent.new("Mozilla", "5.0", ["Windows"]))
  end

  it "should not be eql if both products, versions and comments are not the same" do
    BVUserAgent.new("Mozilla", "5.0", ["Macintosh"]).should_not eql(BVUserAgent.new("Mozilla", "4.0", ["Macintosh"]))
  end

  it "should not be equal? if both products are the same" do
    BVUserAgent.new("Mozilla").should_not equal(BVUserAgent.new("Mozilla"))
  end

  it "should be == if products are the same" do
    BVUserAgent.new("Mozilla").should == BVUserAgent.new("Mozilla")
  end

  it "should be == if products and versions are the same" do
    BVUserAgent.new("Mozilla", "5.0").should == BVUserAgent.new("Mozilla", "5.0")
  end

  it "should not be == if products and versions are the different" do
    BVUserAgent.new("Mozilla", "5.0").should_not == BVUserAgent.new("Mozilla", "4.0")
  end

  it "should return false if comparing different products" do
    BVUserAgent.new("Mozilla").should_not <= BVUserAgent.new("Opera")
  end

  it "should not be > if products are the same" do
    BVUserAgent.new("Mozilla").should_not > BVUserAgent.new("Mozilla")
  end

  it "should not be < if products are the same" do
    BVUserAgent.new("Mozilla").should_not < BVUserAgent.new("Mozilla")
  end

  it "should be >= if products are the same" do
    BVUserAgent.new("Mozilla").should >= BVUserAgent.new("Mozilla")
  end

  it "should be <= if products are the same" do
    BVUserAgent.new("Mozilla").should <= BVUserAgent.new("Mozilla")
  end

  it "should be > if products are the same and version is greater" do
    BVUserAgent.new("Mozilla", "5.0").should > BVUserAgent.new("Mozilla", "4.0")
  end

  it "should not be > if products are the same and version is less" do
    BVUserAgent.new("Mozilla", "4.0").should_not > BVUserAgent.new("Mozilla", "5.0")
  end

  it "should be < if products are the same and version is less" do
    BVUserAgent.new("Mozilla", "4.0").should < BVUserAgent.new("Mozilla", "5.0")
  end

  it "should not be < if products are the same and version is greater" do
    BVUserAgent.new("Mozilla", "5.0").should_not < BVUserAgent.new("Mozilla", "4.0")
  end

  it "should be >= if products are the same and version is greater" do
    BVUserAgent.new("Mozilla", "5.0").should >= BVUserAgent.new("Mozilla", "4.0")
  end

  it "should not be >= if products are the same and version is less" do
    BVUserAgent.new("Mozilla", "4.0").should_not >= BVUserAgent.new("Mozilla", "5.0")
  end

  it "should be <= if products are the same and version is less" do
    BVUserAgent.new("Mozilla", "4.0").should <= BVUserAgent.new("Mozilla", "5.0")
  end

  it "should not be <= if products are the same and version is greater" do
    BVUserAgent.new("Mozilla", "5.0").should_not <= BVUserAgent.new("Mozilla", "4.0")
  end

  it "should be >= if products are the same and version is the same" do
    BVUserAgent.new("Mozilla", "5.0").should >= BVUserAgent.new("Mozilla", "5.0")
  end

  it "should be <= if products are the same and version is the same" do
    BVUserAgent.new("Mozilla", "5.0").should <= BVUserAgent.new("Mozilla", "5.0")
  end
end

describe BVUserAgent, "::MATCHER" do
  it "should not match a blank line" do
    BVUserAgent::MATCHER.should_not =~ ""
  end

  it "should match a single product" do
    BVUserAgent::MATCHER.should =~ "Mozilla"
  end

  it "should match a product and version" do
    BVUserAgent::MATCHER.should =~ "Mozilla/5.0"
  end

  it "should match a product, version, and comment" do
    BVUserAgent::MATCHER.should =~ "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_3; en-us)"
  end

  it "should match a product, and comment" do
    BVUserAgent::MATCHER.should =~ "Mozilla (Macintosh; U; Intel Mac OS X 10_5_3; en-us)"
  end
end

describe BVUserAgent, ".parse" do
  it "should concatenate user agents when coerced to a string" do
    string = BVUserAgent.parse("Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_3; en-us) AppleWebKit/525.18 (KHTML, like Gecko) Version/3.1.1 Safari/525.18")
    string.to_str.should == "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_3; en-us) AppleWebKit/525.18 (KHTML, like Gecko) Version/3.1.1 Safari/525.18"
  end

  it "should parse a single product" do
    useragent = BVUserAgent.new("Mozilla")
    BVUserAgent.parse("Mozilla").application.should == useragent
  end

  it "should parse a single product with version" do
    useragent = BVUserAgent.new("Mozilla", "5.0")
    BVUserAgent.parse("Mozilla/5.0").application.should == useragent
  end

  it "should parse a single product, version, and comment" do
    useragent = BVUserAgent.new("Mozilla", "5.0", ["Macintosh", "U", "Intel Mac OS X 10_5_3", "en-us"])
    BVUserAgent.parse("Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_3; en-us)").application.should == useragent
  end

  it "should parse a single product, version, and comment, with space-padded semicolons" do
    useragent = BVUserAgent.new("Mozilla", "5.0", ["Macintosh", "U", "Intel Mac OS X 10_5_3", "en-us"])
    BVUserAgent.parse("Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_3 ; en-us; )").application.should == useragent
  end

  it "should parse a single product and comment" do
    useragent = BVUserAgent.new("Mozilla", nil, ["Macintosh"])
    BVUserAgent.parse("Mozilla (Macintosh)").application.should == useragent
  end
end

describe BVUserAgent::Browsers::All, "#<" do
  before do
    @ie_7 = BVUserAgent.parse("Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)")
    @ie_6 = BVUserAgent.parse("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)")
    @firefox = BVUserAgent.parse("Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en-US; rv:1.8.1.14) Gecko/20080404 Firefox/2.0.0.14")
  end

  it "should not be < if user agent does not have a browser" do
    @ie_7.should_not < "Mozilla"
  end

  it "should not be < if user agent does not have the same browser" do
    @ie_7.should_not < @firefox
  end

  it "should be < if version is less than its version" do
    @ie_6.should < @ie_7
  end

  it "should not be < if version is the same as its version" do
    @ie_6.should_not < @ie_6
  end

  it "should not be < if version is greater than its version" do
    @ie_7.should_not < @ie_6
  end
end

describe BVUserAgent::Browsers::All, "#<=" do
  before do
    @ie_7 = BVUserAgent.parse("Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)")
    @ie_6 = BVUserAgent.parse("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)")
    @firefox = BVUserAgent.parse("Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en-US; rv:1.8.1.14) Gecko/20080404 Firefox/2.0.0.14")
  end

  it "should not be <= if user agent does not have a browser" do
    @ie_7.should_not <= "Mozilla"
  end

  it "should not be <= if user agent does not have the same browser" do
    @ie_7.should_not <= @firefox
  end

  it "should be <= if version is less than its version" do
    @ie_6.should <= @ie_7
  end

  it "should be <= if version is the same as its version" do
    @ie_6.should <= @ie_6
  end

  it "should not be <= if version is greater than its version" do
    @ie_7.should_not <= @ie_6
  end
end

describe BVUserAgent::Browsers::All, "#==" do
  before do
    @ie_7 = BVUserAgent.parse("Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)")
    @ie_6 = BVUserAgent.parse("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)")
    @firefox = BVUserAgent.parse("Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en-US; rv:1.8.1.14) Gecko/20080404 Firefox/2.0.0.14")
  end

  it "should not be == if user agent does not have a browser" do
    @ie_7.should_not == "Mozilla"
  end

  it "should not be == if user agent does not have the same browser" do
    @ie_7.should_not == @firefox
  end

  it "should not be == if version is less than its version" do
    @ie_6.should_not == @ie_7
  end

  it "should be == if version is the same as its version" do
    @ie_6.should == @ie_6
  end

  it "should not be == if version is greater than its version" do
    @ie_7.should_not == @ie_6
  end
end

describe BVUserAgent::Browsers::All, "#>" do
  before do
    @ie_7 = BVUserAgent.parse("Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)")
    @ie_6 = BVUserAgent.parse("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)")
    @firefox = BVUserAgent.parse("Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en-US; rv:1.8.1.14) Gecko/20080404 Firefox/2.0.0.14")
  end

  it "should not be > if user agent does not have a browser" do
    @ie_7.should_not > "Mozilla"
  end

  it "should not be > if user agent does not have the same browser" do
    @ie_7.should_not > @firefox
  end

  it "should not be > if version is less than its version" do
    @ie_6.should_not > @ie_7
  end

  it "should not be > if version is the same as its version" do
    @ie_6.should_not > @ie_6
  end

  it "should be > if version is greater than its version" do
    @ie_7.should > @ie_6
  end
end

describe BVUserAgent::Browsers::All, "#>=" do
  before do
    @ie_7 = BVUserAgent.parse("Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)")
    @ie_6 = BVUserAgent.parse("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)")
    @firefox = BVUserAgent.parse("Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en-US; rv:1.8.1.14) Gecko/20080404 Firefox/2.0.0.14")
  end

  it "should not be >= if user agent does not have a browser" do
    @ie_7.should_not >= "Mozilla"
  end

  it "should not be >= if user agent does not have the same browser" do
    @ie_7.should_not >= @firefox
  end

  it "should not be >= if version is less than its version" do
    @ie_6.should_not >= @ie_7
  end

  it "should be >= if version is the same as its version" do
    @ie_6.should >= @ie_6
  end

  it "should be >= if version is greater than its version" do
    @ie_7.should >= @ie_6
  end
end

describe BVUserAgent::Version do
  it "should be eql if versions are the same" do
    BVUserAgent::Version.new("5.0").should eql(BVUserAgent::Version.new("5.0"))
  end

  it "should not be eql if versions are the different" do
    BVUserAgent::Version.new("9.0").should_not eql(BVUserAgent::Version.new("5.0"))
  end

  it "should be == if versions are the same" do
    BVUserAgent::Version.new("5.0").should == BVUserAgent::Version.new("5.0")
  end

  it "should be == if versions are the same string" do
    BVUserAgent::Version.new("5.0").should == "5.0"
  end

  it "should not be == if versions are the different" do
    BVUserAgent::Version.new("9.0").should_not == BVUserAgent::Version.new("5.0")
  end

  it "should not be == to nil" do
    BVUserAgent::Version.new("9.0").should_not == nil
  end

  it "should not be == to []" do
    BVUserAgent::Version.new("9.0").should_not == []
  end

  it "should be < if version is less" do
    BVUserAgent::Version.new("9.0").should < BVUserAgent::Version.new("10.0")
  end

  it "should be < if version is less" do
    BVUserAgent::Version.new("4").should < BVUserAgent::Version.new("4.1")
  end

  it "should be < if version is less and a string" do
    BVUserAgent::Version.new("9.0").should < "10.0"
  end

  it "should not be < if version is greater" do
    BVUserAgent::Version.new("9.0").should_not > BVUserAgent::Version.new("10.0")
  end

  it "should be <= if version is less" do
    BVUserAgent::Version.new("9.0").should <= BVUserAgent::Version.new("10.0")
  end

  it "should not be <= if version is greater" do
    BVUserAgent::Version.new("9.0").should_not >= BVUserAgent::Version.new("10.0")
  end

  it "should be <= if version is same" do
    BVUserAgent::Version.new("9.0").should <= BVUserAgent::Version.new("9.0")
  end

  it "should be > if version is greater" do
    BVUserAgent::Version.new("1.0").should > BVUserAgent::Version.new("0.9")
  end

  it "should be > if version is greater" do
    BVUserAgent::Version.new("4.1").should > BVUserAgent::Version.new("4")
  end

  it "should not be > if version is less" do
    BVUserAgent::Version.new("0.0.1").should_not > BVUserAgent::Version.new("10.0")
  end

  it "should be >= if version is greater" do
    BVUserAgent::Version.new("10.0").should >= BVUserAgent::Version.new("4.0")
  end

  it "should not be >= if version is less" do
    BVUserAgent::Version.new("0.9").should_not >= BVUserAgent::Version.new("1.0")
  end

  it "should raise ArgumentError if other is nil" do
    lambda { BVUserAgent::Version.new("9.0").should < nil }.should raise_error(ArgumentError, "comparison of Version with nil failed")
  end
  
  context "comparing with structs" do
    it "should not be < if products are the same and version is greater" do
      BVUserAgent.parse("Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.2; WOW64; Trident/6.0)").should_not < OpenStruct.new(:browser => "Internet Explorer", :version => "7.0")
    end
  end
end
