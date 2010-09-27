require 'rubygems'
require 'spec'
require 'active_support'
require 'lib/preheatt'

describe ActiveSupport::Cache do

  before do
    @cache = ActiveSupport::Cache.lookup_store(:memory_store)
    @cache.clear
  end

  describe "#fetch_with_force" do

    context "block is not given" do

      it "should set :force to true if its not set" do
        @cache.should_receive(:fetch_without_force).with("city", hash_including(:force => true))
        @cache.fetch_with_force("city")
      end

      [true, false].each do |force_value|
        it "should keep :force to true if it is set to #{force_value}" do
          @cache.should_receive(:fetch_without_force).with("city", hash_including(:force => true))
          @cache.fetch_with_force("city", :force => force_value)
        end
      end

      context "after preheat has been enabled" do
        before do
          @cache.enable_preheat
        end

        it "should correctly force a cache miss" do
          @cache.read("dog").should be_nil
          @cache.write("dog", "beagle").should == "beagle"
          @cache.fetch("dog").should be_nil
          @cache.read("dog").should == "beagle"
        end
      end
    end

    context "block is given" do
      it "should set :force to true if its not set" do
        @cache.should_receive(:fetch_without_force).with("city", hash_including(:force => true))
        @cache.fetch_with_force("city") do
          "London"
        end
      end

      [true, false].each do |force_value|
        it "should keep :force to true if it is set to #{force_value}" do
          @cache.should_receive(:fetch_without_force).with("city", hash_including(:force => true))
          @cache.fetch_with_force("city", :force => force_value) do
            "London"
          end
        end
      end

      it "should call fetch_without_force with a block" do
        @cache.should_receive(:fetch_without_force).with("city", hash_including(:force => true)).and_yield(anything)
        @cache.fetch_with_force("city") do
          "foo"
        end
      end

      context "after preheat has been enabled" do
        before do
          @cache.enable_preheat
        end

        it "should correctly set the cache" do
          @cache.read("dog").should be_nil
          @cache.write("dog", "beagle").should == "beagle"
          @cache.fetch("dog") do
            "spaniel"
          end.should == "spaniel"
          @cache.read("dog").should == "spaniel"
        end
      end


    end
  end


  describe "#enable_preheat" do
    it "should switch force to be true for all fetch calls after it" do
      @cache.should_receive(:fetch).exactly(2).times.with("before-enable")
      @cache.should_receive(:fetch).exactly(2).times.with("after-enable",hash_including(:force => true))

      @cache.fetch("before-enable")
      @cache.fetch("before-enable") do
        "Foo"
      end

      @cache.enable_preheat
      @cache.fetch("after-enable")
      @cache.fetch("after-enable") do
        "Foo"
      end
    end
  end

  describe "#disable_preheat" do
    it "should switch force to be default active support behavior for all fetch calls after it" do
      @cache.should_receive(:fetch).exactly(2).times.with("after-disable")
      @cache.should_receive(:fetch).exactly(2).times.with("before-disable",hash_including(:force => true))

      @cache.enable_preheat
      @cache.fetch("before-disable")
      @cache.fetch("before-disable") do
        "Foo"
      end
      @cache.disable_preheat
      @cache.fetch("after-disable")
      @cache.fetch("after-disable") do
        "Foo"
      end

    end
  end

end


describe Preheat do


  before do
    @cache = ActiveSupport::Cache.lookup_store(:memory_store)
    silence_warnings {
      Object.const_set "RAILS_CACHE", @cache
    }
    @cache.clear
  end

  describe "it" do

    context "no block given" do
      it "should enable preheat when called" do
        @cache.should_receive(:enable_preheat)
        @cache.stub!(:disable_preheat)
        Preheat.it
      end

      it "should disable preheat when called" do
        @cache.stub!(:enable_preheat)
        @cache.should_receive(:disable_preheat)
        Preheat.it
      end
    end

    context "block given" do
      it "should enable preheat when called" do
        @cache.should_receive(:enable_preheat)
        @cache.stub!(:disable_preheat)
        Preheat.it do
          "hello"
        end
      end

      it "should disable preheat when called" do
        @cache.stub!(:enable_preheat)
        @cache.should_receive(:disable_preheat)
        Preheat.it do
          "goodbye"
        end
      end

      it "should execute the block given" do
        Preheat.it do
          @cache.fetch("city") do
            "test"
          end
        end
        @cache.read("city").should == "test"
      end
    end

  end


  context "integration tests" do

    it "should not suck :)" do
      @cache.read("dog").should be_nil
      @cache.write("dog", "beagle").should == "beagle"
      @cache.fetch("dog").should == "beagle"
      @cache.fetch("dog") do
        "poodle"
      end.should == "beagle"
      @cache.fetch("dog", :force => true) do
        "lab"
      end.should == "lab"

      @cache.fetch("dog") do
        "spaniel"
      end.should == "lab"

      Preheat.it do
        @cache.fetch("dog") do
          "pug"
        end.should == "pug"
      end

      @cache.read("dog").should == "pug"
      @cache.fetch("dog") do
        "bulldog"
      end.should == "pug"
    end
  end
end
